//
//  ModelData.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/20/21.
//

import Foundation
import Combine
import ActivityKit

class ModelData: ObservableObject {
    
    // Trips
    @Published var trips: [Trip] = []
    
    // Checklist
    @Published var checklist: [ChecklistItem] = []
    @Published var checklistPhase: TripMode = .pretrip
    @Published var showCompleted = true     //TODO: persist
    
    // Power
    @Published var rv: Float = 0.0
    @Published var tesla: Float = 0.0
    internal var linePower: [Float] = [0.0, 0.0]
    internal var powerActivity: Activity<PatriotRvWidgetAttributes>?
    
    let mqtt: Publishing!
    
    init(mqttManager: any Publishing) {
        mqtt = mqttManager
        mqtt.messageHandler = { topic, message in
            // t: patriot/state/ALL/X/<checklistitem> m:<0|1>
            let lcTopic: String = topic.lowercased()
            if lcTopic.hasPrefix("patriot/state/all/x/") {
                let components = lcTopic.components(separatedBy: "/")
                if components.count > 4 {
                    self.setDone(checklistitem: components[4], value: message)
                }
                // Handle power messages
            }else if lcTopic == "shellies/em/emeter/0/power" {
                self.updatePower(line: 0, power: Float(message) ?? 0.0)
            }else if lcTopic == "shellies/em/emeter/1/power" {
                self.updatePower(line: 1, power: Float(message) ?? 0.0)
            }
        }
        
        // Load Checklist after MQTT is initialized
        checklist = Checklist.initialChecklist
        for i in 0..<checklist.count {
            checklist[i].delegate = self.mqtt
        }
        
        // Load trips
        initializeTrips()
    }
}

extension ModelData {
    
    func currentPhase(date: Date) -> TripMode {
        guard nextTrip(date: date) != nil else {
            return .parked
        }
        return nextItem()?.category ?? .parked
    }
    
    // Called when MQTT reports on a checklist item (patriot/state/all/x/<checklistitem>
    func setDone(checklistitem: String, value: String) {
        for index in 0..<checklist.count {
            if checklist[index].id.lowercased() == checklistitem.lowercased() {
                checklist[index].isDone = value != "0"
            }
        }
    }
    
    func item(_ checklistitem: String) -> ChecklistItem? {
        return checklist.filter { $0.id == checklistitem }.first
    }
    
    func uncheckAll() {
        for index in 0..<checklist.count {
            checklist[index].isDone = false
        }
    }
    
    // Use the other funcs to filter first
    // eg next todo in Departure:
    //   checklist.category("Departure").nextItem()
    func nextItem() -> ChecklistItem? {
        return checklist.todo().first
    }
    
    func checklistDisplayItems() -> [ChecklistItem] {
        if showCompleted == true {
            return checklist.category(checklistPhase)
        } else {
            return checklist.category(checklistPhase).todo()
        }
    }
    
    // For now persisting to UserDefaults
    func saveChecklist() {
        let tripMode = currentPhase(date: Date()).rawValue
        UserDefaults(suiteName: "group.net.lisles.patriotrv")!.setValue(tripMode, forKey: "TripMode")
        
        if let item = nextItem() {
            UserDefaults(suiteName: "group.net.lisles.patriotrv")!.setValue(item.name, forKey: "NextItem")
        }
    }

        
}

extension Array where Element == ChecklistItem {

    func done() -> [ChecklistItem] {
        return self.filter { $0.isDone == true }
    }

    func todo() -> [ChecklistItem] {
        return self.filter { $0.isDone == false }
    }

    func category(_ category: TripMode) -> [ChecklistItem] {
        return self.filter { $0.category == category }
    }
}
