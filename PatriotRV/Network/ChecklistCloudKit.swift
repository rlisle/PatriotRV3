//
//  ChecklistCloudKit.swift
//  PatriotRV
//
//  Created by Ron Lisle on 4/5/23.
//

import CloudKit

//TODO: Convert ChecklistItem to CKRecord?

extension ViewModel {
    
    nonisolated func loadChecklist() async throws {
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
    
    private nonisolated func fetchChecklist() async throws -> [ChecklistItem] {
        let pred = NSPredicate(value: true)     // All records
        let sort = NSSortDescriptor(key: "sortOrder", ascending: true)
        let query = CKQuery(recordType: "Checklist", predicate: pred)
        query.sortDescriptors = [sort]
        
        let response = try await CKContainer.default().publicCloudDatabase.records(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 500)
        let records = response.matchResults.compactMap { try? $0.1.get() }
        return records.compactMap(ChecklistItem.init)
    }

    func deleteChecklist() async throws {
        for item in checklist {
            try await deleteChecklistItem(item)
        }
        checklist = []
        try await saveChecklist()
    }
    
    private nonisolated func deleteChecklistItem(_ item: ChecklistItem) async throws {
        guard !item.key.isEmpty else {
            print("Attempt to delete checklist item with empty key")
            return
        }
        let database = CKContainer.default().publicCloudDatabase
        let recordID = CKRecord.ID(recordName: item.key)
        do {
            _ = try await database.deleteRecord(withID: recordID)
        } catch {
            print("Error deleting checklist item \(item.name): \(error)")
        }
    }

    func saveChecklist() async throws {
        // Do we need to delete all existing records first?
        for item in checklist {
            //TODO: batch these
            try await saveChecklistItem(item)
        }
    }
    
    nonisolated func saveChecklistItem(_ item: ChecklistItem) async throws {
        guard !item.key.isEmpty else {
            print("Attempt to save checklist item with empty key")
            return
        }
        let database = CKContainer.default().publicCloudDatabase
        let recordID = CKRecord.ID(recordName: item.key)
        let record = CKRecord(recordType: "Checklist", recordID: recordID)
        record.setValuesForKeys([
            "name": item.name,
            "tripMode": item.tripMode.rawValue,
            "description": item.description,
            "sortOrder": item.sortOrder,
            "isDone": item.isDone,
            "date": item.date ?? Date()
        ])
        do {
            try await database.save(record)
        } catch {
            print("Error saving checklist item \(item.name): \(error)")
        }
    }
}
