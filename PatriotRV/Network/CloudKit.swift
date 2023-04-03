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
    
    nonisolated func asyncLoadTrips() async throws {
        
        let pred = NSPredicate(value: true)     // All records
        let sort = NSSortDescriptor(key: "date", ascending: false)
        let query = CKQuery(recordType: "Trip", predicate: pred)
        query.sortDescriptors = [sort]
        
        do {
            let response = try await CKContainer.default().publicCloudDatabase.records(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 500)
            for (_, result) in response.matchResults {
                switch result {
                case .success(let record):
                    if let trip = Trip(from: record) {
                        await MainActor.run {
                            trips.append(trip)
                        }
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            
        } catch {
            print("Error fetching trips")
            throw error
        }
    }

    func setLoadingTrip() {
        trips.append(Trip(
            date: Date("01/01/23"),
            destination: "TBD",
            notes: "Loading trips...",
            address: nil,
            imageName: nil,
            website: nil))
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
    
    nonisolated func asyncLoadChecklist() async throws {
        do {
            let records = try await fetchChecklist()
            await MainActor.run {
                checklist = records
            }
            
        } catch {
            print("Error fetching checklist")
            throw error
        }
    }
    
    nonisolated func fetchChecklist() async throws -> [ChecklistItem] {
        let pred = NSPredicate(value: true)     // All records
        let sort = NSSortDescriptor(key: "sortOrder", ascending: true)
        let query = CKQuery(recordType: "Checklist", predicate: pred)
        query.sortDescriptors = [sort]
        let response = try await CKContainer.default().publicCloudDatabase.records(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 500)
        let records = response.matchResults.compactMap { try? $0.1.get() }
        return records.compactMap(ChecklistItem.init)
    }

    func saveChecklist() {
        for item in checklist {
            saveChecklistItem(item)
        }
    }
    
    func saveChecklistItem(_ item: ChecklistItem) {
        let database = CKContainer.default().publicCloudDatabase
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
                print("Error saving checklist item \(item.name): \(error)")
                 return
             }
        }
    }
}
