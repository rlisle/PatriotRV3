//
//  ModelData.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/20/21.
//

import SwiftUI
import ActivityKit
import WidgetKit
import CloudKit
import PhotosUI
import CoreTransferable


@MainActor
class ViewModel: ObservableObject {
    
    @Published var trips: [Trip] = []
    @Published var checklist: [ChecklistItem] = []
    @Published var maintenance: [ChecklistItem] = []

    @Published var tripPhotoData: Data?
    
    @Published var nextItemIndex: Int? = 0             // Updated when any item isDone changed

    @Published var displayPhase: TripMode = .pretrip  // Selected for display
    @Published var showCompleted = true                 //TODO: persist
    
    // Images
//    @Published private(set) var imageState: ImageState = .empty
//    @Published var imageSelection: PhotosPickerItem? = nil {
//        didSet {
//            if let imageSelection {
//                let progress = loadTransferable(from: imageSelection)
//                imageState = .loading(progress)
//            } else {
//                imageState = .empty
//            }
//        }
//    }
    
    internal var checklistActivity: Activity<PatriotRvWidgetAttributes>?

    // Power
    @Published var rv: Float = 0.0
    @Published var tesla: Float = 0.0
    internal var linePower: [Float] = [0.0, 0.0]        // Amps
    internal var powerActivity: Activity<PatriotRvWidgetAttributes>?
    
    internal let formatter = DateFormatter()

    var mqtt: MQTTManagerProtocol                       // Protocol to simplify unit tests
    
    var mockData = false
    
    
    // For use with previews and tests
    convenience init() {
        let mqttManager = MockMQTTManager()
        self.init(mqttManager: mqttManager)
        self.updatePower(line: 0, power: 480.0)
        self.updatePower(line: 1, power: 2880.0)
        //TODO: set dummy trips & checklist instead of loading from CloudKit
        mockData = true
        seedTrips()
        seedChecklist()
        seedMaintenance()
    }
    
    init(mqttManager: MQTTManagerProtocol) {
        mqtt = mqttManager
        mqtt.messageHandler = { topic, message in
            self.handleMQTTMessage(topic: topic, message: message)
        }
        formatter.dateFormat = "yyyy-MM-dd"

        // Note: don't load from iCloud if Preview or testing
        
        setLoadingTrip()
        //TODO: perform this in parallel
        Task {
            do {
                try await loadTrips()
                try await loadChecklist()
                //TODO: loadMaintenance()
            } catch {
                print("Error fetching from iCloud: \(error)")
            }
        }
    }
    
    // I'd rather this be in ImageModel, but it complains about the 'private'
//    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
//        return imageSelection.loadTransferable(type: ChecklistImage.self) { result in
//            DispatchQueue.main.async {
//                guard imageSelection == self.imageSelection else {
//                    print("Failed to get the selected item.")
//                    return
//                }
//                switch result {
//                case .success(let profileImage?):
//                    self.imageState = .success(profileImage.image)
//                case .success(nil):
//                    self.imageState = .empty
//                case .failure(let error):
//                    self.imageState = .failure(error)
//                }
//            }
//        }
//    }
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
        //TODO: perform save (if not mockData)?
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
        if !mockData {
            Task {
                try? await saveChecklistItem(item)
            }
        }
        
        updateNextItemIndex()
        persistNextItem()
    }
    
    func updateNextItemIndex() {
        let index = checklist.firstIndex {
            $0.isDone == false
        }
        guard let index = index,
              index >= 0 && index < checklist.count else {
            print("Checklist empty or all items done")
            return
        }
        nextItemIndex = index
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
