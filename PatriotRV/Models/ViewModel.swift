//
//  ModelData.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/20/21.
//

import Foundation
import Combine
import ActivityKit
import WidgetKit

class ViewModel: ObservableObject {
    
    //TODO: add persistence and editing of trips
    @Published var trips: [Trip] = []
    
    // Checklist - persisted by Photon controllers
    @Published var checklist: [ChecklistItem] = []

    // NextItem
    @Published var nextItemIndex: Int? = 0             // Updated when an item is set isDone

    // Display Controls
    @Published var displayPhase: TripMode = .pretrip  // Selected for display
    @Published var showCompleted = true                 //TODO: persist
    
    // Power
    @Published var rv: Float = 0.0
    @Published var tesla: Float = 0.0
    
    internal var linePower: [Float] = [0.0, 0.0]        // Amps
    internal var powerActivity: Activity<PatriotRvWidgetAttributes>?
    
    // MQTT
    var mqtt: MQTTManagerProtocol                       // Protocol to simplify unit tests
    
    
    //private var cancellable: AnyCancellable?            // Not currently needed?

    // For use with previews and tests
    convenience init() {
        let mqttManager = MockMQTTManager()
        self.init(mqttManager: mqttManager)
        self.updatePower(line: 0, power: 480.0)
        self.updatePower(line: 1, power: 2880.0)
    }
    
    init(mqttManager: MQTTManagerProtocol) {
        mqtt = mqttManager
        mqtt.messageHandler = { topic, message in
            self.handleMQTTMessage(topic: topic, message: message)
        }
        
        initializeTrips()
        initializeChecklist()
        
//        cancellable = $checklist
//            .receive(on: DispatchQueue.main)
//            //.print("Combine: checklist changed\n")
//            .sink(receiveValue: { newChecklist in
//                  print("TODO: update widgets and watch")
//            })
        
//        Connectivity.shared.$lastDoneId
//            .dropFirst()
//            .receive(on: DispatchQueue.main)
//            //.assign(to: \.lastCompleted, on: self)
//            .sink(receiveValue: {
//                guard (0...self.checklist.count).contains($0) else {
//                    print("Invalid lastDoneId received")
//                    return
//                }
//                self.checklist[$0].isDone = true
//            })
//            .store(in: &cancellable)
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
                self.setDone(key: components[4], isDone: isDone)
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
        updateWidgetNextItem()  // Why is this here and not in ChecklistItem.isDone (the caller)?
                                // Because ChecklistItem doesn't have a reference to ModelData (delegate?)
    }
}

// Checklist
extension ViewModel {

    func initializeChecklist() {
        checklist = Checklist.initialChecklist
    }
    
    func index(key: String) -> Int? {
        checklist.firstIndex { $0.key == key }
    }
    
    func updateNextItemIndex() {
        print("updateNextItemIndex")
        nextItemIndex = checklist.firstIndex { $0.isDone == false }
    }

    // Called when MQTT reports on a checklist item (patriot/state/all/x/<checklistitem>
    func setDone(key: String, isDone: Bool = true) {
        guard let index = index(key: key) else { return }
        checklist[index].isDone = isDone
        checklist[index].date = Date()
        updateWidgetNextItem()
    }

    // Called when checkbox tapped
    func toggleDone(key: String) {
        guard let index = index(key: key) else { return }
        checklist[index].isDone.toggle()
        updateNextItemIndex()
    }

    func updateWidgetNextItem() {
        print("updateWidgetNextItem")
        guard let nextItem = checklist.todo().first else {
            print("updateWidgetNextItem: no next item")
            return
        }
        let doneCount = checklist.category(nextItem.tripMode).done().count
        let totalCount = checklist.category(nextItem.tripMode).count
        print("Updating widget nextItem: \(nextItem.tripMode): \(nextItem.name) \(doneCount) of \(totalCount)")
        
        UserDefaults.group.set(nextItem.name, forKey: UserDefaults.Keys.nextItem.rawValue)
        UserDefaults.group.set(nextItem.tripMode.rawValue, forKey: UserDefaults.Keys.tripMode.rawValue)
        UserDefaults.group.set(doneCount, forKey: UserDefaults.Keys.doneCount.rawValue)
        UserDefaults.group.set(totalCount, forKey: UserDefaults.Keys.totalCount.rawValue)
        WidgetCenter.shared.reloadTimelines(ofKind: Constants.checklistKind)
        
        //TODO: still needed, or use the above instead?
        Connectivity.shared.send(key: nextItem.key)
    }
    
    func item(_ checklistitem: String) -> ChecklistItem? {
        return checklist.filter { $0.key == checklistitem }.first
    }
    
    func uncheckAll() {
        for index in 0..<checklist.count {
            checklist[index].isDone = false
        }
    }
    
//    func doneIds() -> [Int] {
//        return checklist.done().map { $0.id }
//    }
    
    // Use the other funcs to filter first
    // eg next todo in Departure:
    //   checklist.category("Departure").nextItem()
//    func nextItem() -> ChecklistItem? {
//        return checklist.todo().first
//    }
    
//    func checklistDisplayItems() -> [ChecklistItem] {
//        if showCompleted == true {
//            return checklist.category(checklistPhase)
//        } else {
//            return checklist.category(checklistPhase).todo()
//        }
//    }
//
//    // For now persisting to UserDefaults
//    func saveChecklist() {
//        let tripMode = currentPhase(date: Date()).rawValue
//        UserDefaults(suiteName: "group.net.lisles.patriotrv")!.setValue(tripMode, forKey: "TripMode")
//
//        if let item = nextItem() {
//            UserDefaults(suiteName: "group.net.lisles.patriotrv")!.setValue(item.name, forKey: "NextItem")
//        }
//    }

        
}
