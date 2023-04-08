//
//  ModelData.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/20/21.
//

import Foundation
import ActivityKit
import WidgetKit
import CloudKit


@MainActor
class ViewModel: ObservableObject {
    
    @Published var trips: [Trip] = []
    
    // Checklist - persisted by Photon controllers
    @Published var checklist: [ChecklistItem] = []

    // NextItem
    @Published var nextItemIndex: Int? = 0             // Updated when an item is set toggle by checkbox

    // Display Controls
    @Published var displayPhase: TripMode = .pretrip  // Selected for display
    @Published var showCompleted = true                 //TODO: persist
    
    internal var checklistActivity: Activity<PatriotRvWidgetAttributes>?

    // Power
    @Published var rv: Float = 0.0
    @Published var tesla: Float = 0.0
    
    internal var linePower: [Float] = [0.0, 0.0]        // Amps
    internal var powerActivity: Activity<PatriotRvWidgetAttributes>?
    
    internal let formatter = DateFormatter()

    // MQTT
    var mqtt: MQTTManagerProtocol                       // Protocol to simplify unit tests
    
    
    // For use with previews and tests
    convenience init() {
        let mqttManager = MockMQTTManager()
        self.init(mqttManager: mqttManager)
        self.updatePower(line: 0, power: 480.0)
        self.updatePower(line: 1, power: 2880.0)
        //TODO: set dummy trips & checklist instead of loading from CloudKit
    }
    
    init(mqttManager: MQTTManagerProtocol) {
        mqtt = mqttManager
        mqtt.messageHandler = { topic, message in
            self.handleMQTTMessage(topic: topic, message: message)
        }
        formatter.dateFormat = "yyyy-MM-dd"

        setLoadingTrip()
        //TODO: perform this in parallel
        Task {
            do {
                try await loadTrips()
                try await loadChecklist()
            } catch {
                print("Error fetching from iCloud: \(error)")
            }
        }
    }
}

// Handle MQTT messages
extension ViewModel {
    func handleMQTTMessage(topic: String, message: String) {
        
        // Handle Checklist messages
        // t: patriot/state/ALL/X/<checklistitem> m:<0|1>
        let lcTopic: String = topic.lowercased()
        if lcTopic.hasPrefix("patriot/state/all/x/") {
            let components = lcTopic.components(separatedBy: "/")
            if components.count > 4 {
                let isDone = message != "0"
                self.updateDone(key: components[4], value: isDone)
            }
            
        // Handle power messages
        }else if lcTopic == "shellies/em/emeter/0/power" {
            self.updatePower(line: 0, power: Float(message) ?? 0.0)
        }else if lcTopic == "shellies/em/emeter/1/power" {
            self.updatePower(line: 1, power: Float(message) ?? 0.0)
        }
        
    }
}

extension ViewModel: Publishing {
    func publish(key: String, isDone: Bool) {
        mqtt.publish(topic: "patriot/\(key)/set", message: isDone ? "100" : "0")
        // checklistPhase = currentPhase(date: Date())
        persistNextItem()  // Why is this here and not in ChecklistItem.isDone (the caller)?
                                // Because ChecklistItem doesn't have a reference to ModelData (delegate?)
    }
}

// Checklist
extension ViewModel {

    func eliminateDuplicates() {
        var newChecklist = [ChecklistItem]()
        for item in checklist {
            if !newChecklist.contains(item) {
                newChecklist.append(item)
            }
        }
        guard newChecklist.count > 0 else {
            print("Error in eliminateDuplicates. No records")
            return
        }
        Task {
            await MainActor.run {
                checklist = newChecklist
            }
        }
        //TODO: perform save?
    }
    
    func index(key: String) -> Int? {
        checklist.firstIndex { $0.key == key }
    }
    
    // Replaces setDone and toggleDone also
    func updateDone(key: String, value: Bool? = nil) {    // Set true/false/nil = toggle
        guard let index = index(key: key) else {
            print("updateDone invalid key: \(key)")
            return
        }
        var item = checklist[index]
        if let value = value {
            item.isDone = value
        } else {
            item.isDone.toggle()
        }
        item.date = Date()
        checklist[index] = item
        Task {
            try? await saveChecklistItem(item)
        }
        
        updateNextItemIndex()
        persistNextItem()
    }
    
    private func updateNextItemIndex() {
        nextItemIndex = checklist.firstIndex {
            $0.isDone == false
        }
        print("updateNextItemIndex nextItemIndex = \(String(describing: nextItemIndex))")
    }

    // Save nextItem for use by widgets, etc.
    private func persistNextItem() {
        print("persistNextItem")
        guard let nextIndex = nextItemIndex,
              nextIndex > 0 && nextIndex < checklist.count else {
            print("updateWidgetNextItem: no next item")
            return
        }
        let nextItem = checklist[nextIndex]
        let doneCount = checklist.category(nextItem.tripMode).done().count
        let totalCount = checklist.category(nextItem.tripMode).count
        print("Updating widget nextItem: \(nextItem.tripMode): \(nextItem.name) \(doneCount) of \(totalCount)")
        
        UserDefaults.group.set(nextItem.name, forKey: UserDefaults.Keys.nextItem.rawValue)
        UserDefaults.group.set(nextItem.tripMode.rawValue, forKey: UserDefaults.Keys.tripMode.rawValue)
        UserDefaults.group.set(doneCount, forKey: UserDefaults.Keys.doneCount.rawValue)
        UserDefaults.group.set(totalCount, forKey: UserDefaults.Keys.totalCount.rawValue)
        //TODO: nextTrip?
        
        // Tell widget to update
        updateChecklistActivity()
        print("Telling widgetcenter to reload checklist timelines")
        WidgetCenter.shared.reloadTimelines(ofKind: Constants.checklistKind)

        // Tell watch to update
        Connectivity.shared.send(key: nextItem.key)
    }
    
    func item(_ checklistitem: String) -> ChecklistItem? {
        return checklist.filter { $0.key == checklistitem }.first
    }
    
    func uncheckAll() {
        for index in 0..<checklist.count {
            checklist[index].isDone = false
        }
        nextItemIndex = 0
    }
}
