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
    
    @Published var trips: [Trip] = []
    @Published var checklist: [ChecklistItem] = []
    @Published var checklistPhase: TripMode = .pretrip  // Selected for display
    @Published var showCompleted = true                 //TODO: persist
    
    // Power
    @Published var rv: Float = 0.0
    @Published var tesla: Float = 0.0
    internal var linePower: [Float] = [0.0, 0.0]        // Amps
    internal var powerActivity: Activity<PatriotRvWidgetAttributes>?
    
    var mqtt: MQTTManagerProtocol
    
    private var cancellable: Set<AnyCancellable> = []

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
        
        //TODO: convert delegate to Combine
        // or pass mqtt to the checklist
        checklist = Checklist.initialChecklist
        for i in 0..<checklist.count {
            checklist[i].id = i+1
            checklist[i].delegate = self
        }
        
        // Load trips
        initializeTrips()
        
        
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

extension ModelData: Publishing {
    func publish(id: Int, isDone: Bool) {
        mqtt.publish(topic: "patriot/\(id)", message: isDone ? "100" : "0")
//        checklistPhase = currentPhase(date: Date())
        updateWatchNextItem()
    }
}

extension ModelData {
    
//    func currentPhase(date: Date) -> TripMode {
//        guard nextTrip(date: date) != nil else {
//            print("currentPhase = .parked because nextTrip = nil")
//            return .parked
//        }
//        return nextItem()?.category ?? .parked
//    }
    
    // Called when MQTT reports on a checklist item (patriot/state/all/x/<checklistitem>
    func setDone(checklistitem: String, value: String) {
        for index in 0..<checklist.count {
            if checklist[index].key.lowercased() == checklistitem.lowercased() {
                checklist[index].isDone = value != "0"
            }
        }
        updateWatchNextItem()
    }
    
    func updateWatchNextItem() {
        print("Updating watch nextItem")
        let nextItemId = checklist.todo().first?.id ?? 0
        Connectivity.shared.send(nextItemId: nextItemId)
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
