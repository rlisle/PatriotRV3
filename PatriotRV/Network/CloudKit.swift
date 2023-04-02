//
//  CloudKit.swift
//  PatriotRV
//
//  Created by Ron Lisle on 4/2/23.
//

import CloudKit

extension ViewModel {
    
    func checkAccountStatus() async throws -> CKAccountStatus {
        try await CKContainer.default().accountStatus()
    }
    
    func save() {
        saveChecklist()
        saveTrips()
    }
}

// Trip
extension ViewModel {
    
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



// Checklist
extension ViewModel {
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
}
