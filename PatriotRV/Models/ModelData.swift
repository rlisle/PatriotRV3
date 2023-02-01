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

    // Power
    @Published var rv: Float = 0.0
    @Published var tesla: Float = 0.0
    internal var linePower: [Float] = [0.0, 0.0]
    internal var powerActivity: Activity<PatriotRvWidgetAttributes>?

    let mqtt: MQTTManagerProtocol!
    
    init(mqttManager: MQTTManagerProtocol) {
        mqtt = mqttManager
        mqtt.messageHandler = { topic, message in
            // t: patriot/state/ALL/X/<checklistitem> m:<0|1>
            let lcTopic: String = topic.lowercased()
            if lcTopic.hasPrefix("patriot/state/all/x/") {
                let components = lcTopic.components(separatedBy: "/")
                if components.count > 4 {
                    self.setItem(checklistitem: components[4], value: message)
                }
            // Handle power messages
            }else if lcTopic == "shellies/em/emeter/0/power" {
                self.updatePower(line: 0, power: Float(message) ?? 0.0)
            }else if lcTopic == "shellies/em/emeter/1/power" {
                self.updatePower(line: 1, power: Float(message) ?? 0.0)
            }
        }
        
        // Load items after MQTT is initialized
        initializeList()
        for i in 0..<checklist.count {
            checklist[i].mqtt = self.mqtt
        }
        
        // Load trips (for now hardcode a few)
        trips.append(Trip(
            date: Date("07/26/22"),
            destination: "Wildwood RV and Golf Resort",
            notes: "Summer location, near Windsor, ON",
            address: "11112 11th Concession Rd, McGregor, ON NOR 1JO",
            imageName: nil,
            category: .arrival,
            sequence: 0,
            isDone: true,
            website: "https://www.wildwoodgolfandrvresort.com"))
    }
    
    func checklist(category: String) -> [ChecklistItem] {
        return checklist.filter { $0.category == category }
    }
    
    func uncheckAll() {
        for index in 0..<checklist.count {
            checklist[index].isDone = false
        }
    }
    
    func numSelectedDone(category: String) -> Int {
        return checklist(category: category).filter { $0.isDone }.count
    }
    
    func numSelectedItems(category: String) -> Int {
        return checklist(category: category).count
    }
    
    func category() -> TripMode {
        return .parked
    }
    
    // Called when MQTT reports on a checklist item (patriot/state/all/x/<checklistitem>
    func setItem(checklistitem: String, value: String) {
        for index in 0..<checklist.count {
            if checklist[index].id.lowercased() == checklistitem.lowercased() {
                checklist[index].isDone = value != "0"
            }
        }
    }
    
    func getItem(_ checklistitem: String) -> ChecklistItem? {
        return checklist.filter { $0.id == checklistitem }.first
    }
}
