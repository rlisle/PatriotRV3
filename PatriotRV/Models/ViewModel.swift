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
    
    //TODO: add persistence and editing of trips
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
    
    // MQTT
    var mqtt: MQTTManagerProtocol                       // Protocol to simplify unit tests
    
    
    // For use with previews and tests
    convenience init() {
        let mqttManager = MockMQTTManager()
        self.init(mqttManager: mqttManager)
        self.updatePower(line: 0, power: 480.0)
        self.updatePower(line: 1, power: 2880.0)
        //TODO: set dummy trips & checklist
    }
    
    init(mqttManager: MQTTManagerProtocol) {
        mqtt = mqttManager
        mqtt.messageHandler = { topic, message in
            self.handleMQTTMessage(topic: topic, message: message)
        }
        
        //loadTrips()
        loadChecklist()
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

    func initializeChecklist() {
        checklist = Checklist.initialChecklist
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
        if let value = value {
            checklist[index].isDone = value
        } else {
            checklist[index].isDone.toggle()
        }
        checklist[index].date = Date()
        
        updateNextItemIndex()
        persistNextItem()
    }
    
    private func updateNextItemIndex() {
        nextItemIndex = checklist.firstIndex {
            $0.isDone == false
        }
    }

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

// CloudKit
extension ViewModel {
    func checkAccountStatus() async throws -> CKAccountStatus {
        try await CKContainer.default().accountStatus()
    }
    
    func save() {
        saveChecklist()
        saveTrips()
    }

    // Load checklist from iCloud
    func loadChecklist() {
        let pred = NSPredicate(value: true)     // All records
        let sort = NSSortDescriptor(key: "sortOrder", ascending: true)
        let query = CKQuery(recordType: "Checklist", predicate: pred)
        query.sortDescriptors = [sort]

         let operation = CKQueryOperation(query: query)
         //operation.desiredKeys = ["key", "name", "tripMode", "description", "sortOrder", "imageName", "isDone"]
         //operation.resultsLimit = 500

         var newChecklist = [ChecklistItem]()
        
        operation.recordFetchedBlock = { record in
            if let item = ChecklistItem(from: record) {
                newChecklist.append(item)
            }
        }
        
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            Task {
                await MainActor.run {
                    if error == nil {
                        self.checklist = newChecklist
                    } else {
                        print("Fetch checklist failed: \(error!.localizedDescription)")
                    }
                }
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
//    func fetchChecklist() async throws -> [ChecklistItem] {
//        let pred = NSPredicate(value: true)     // All records
//        let sort = NSSortDescriptor(key: "sortOrder", ascending: true)
//        let query = CKQuery(recordType: "Checklist", predicate: pred)
//        query.sortDescriptors = [sort]
//        let result = try await CKContainer.default().privateCloudDatabase.records(matching: query)
//        let records = result.matchResults.compactMap { try? $0.1.get() }
//        var newChecklist = [ChecklistItem]()
//        for record in records {
//            print("record = \(record)")
//            let item = ChecklistItem(
//                key: record["key"] as! String,
//                name: record["name"] as! String,
//                category: TripMode(rawValue: record["tripMode"] as? String ?? "Pre-Trip") ?? .pretrip,
//                description: record["description"] as! String,
//                sortOrder: record["sortOrder"] as! Int)
//            newChecklist.append(item)
//        }
////        let records = result.matchResults.compactMap { try? $0.1.get() }
////        return records.compactMap(Fasting.init)
//        return newChecklist
//    }

    func saveChecklist() {
        let container = CKContainer.default()
        let database = container.publicCloudDatabase
        for item in checklist {
            let record = CKRecord(recordType: "Checklist")
            record.setValuesForKeys([
                "key": item.key,
                "name": item.name,
                "tripMode": item.tripMode.rawValue,
                "description": item.description,
                "sortOrder": item.sortOrder,
                "isDone": item.isDone,
                "date": item.date ?? Date()
            ])
            database.save(record) { record, error in
                if let error = error {
                     // Handle error.
                    print("Error saving checklist: \(error)")
                     return
                 }
                 // Record saved successfully.
                print("Checklist record saved to cloud")
            }
        }
    }
    
    // Danger! This will add all of the initial 'seed' built-in values to the database.
    func seedDatabase() {
        let container = CKContainer.default()
        let database = container.publicCloudDatabase
        for item in Checklist.initialChecklist {
            let record = CKRecord(recordType: "Checklist")
            record.setValuesForKeys([
                "key": item.key,
                "name": item.name,
                "tripMode": item.tripMode.rawValue,
                "description": item.description,
                "sortOrder": item.sortOrder,
                "isDone": item.isDone,
                "date": item.date ?? Date()
            ])
            database.save(record) { record, error in
                if let error = error {
                     // Handle error.
                    print("Error saving checklist record: \(error)")
                     return
                 }
                 // Record saved successfully.
                print("Initial checklist record saved to cloud")
            }
        }

    }
    
    // Load trips from iCloud
    func loadTrips() {
        let pred = NSPredicate(value: true)     // All records
        let sort = NSSortDescriptor(key: "date", ascending: false)
        let query = CKQuery(recordType: "Trip", predicate: pred)
        query.sortDescriptors = [sort]

         let operation = CKQueryOperation(query: query)
         //operation.desiredKeys = ["key", "name", "tripMode", "description", "sortOrder", "imageName", "isDone"]
         //operation.resultsLimit = 500

         var newTrips = [Trip]()
        
        operation.recordFetchedBlock = { record in
            if let trip = Trip(from: record) {
                newTrips.append(trip)
            }
        }
        
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            Task {
                await MainActor.run {
                    if error == nil {
                        self.trips = newTrips
                    } else {
                        print("Fetch trips failed: \(error!.localizedDescription)")
                    }
                }
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }

    func saveTrips() {
        let container = CKContainer.default()
        let database = container.publicCloudDatabase
        for trip in trips {
            let record = CKRecord(recordType: "Trip")
            record.setValuesForKeys([
                "date": trip.date,
                "destination": trip.destination,
                "notes": trip.notes ?? "",
                "address": trip.address ?? "?",
                "imageName": trip.imageName ?? "none",
                "website": trip.website ?? "none"
            ])
            database.save(record) { record, error in
                if let error = error {
                     // Handle error.
                    print("Error saving trips: \(error)")
                     return
                 }
                 // Record saved successfully.
                print("Trip record saved to cloud")
            }
        }
    }
}
