//
//  ChecklistItem.swift
//  RvChecklist
//
//  This item should only be updated via the ModelData
//
//  Created by Ron Lisle on 2/12/21.
//

import SwiftUI
import CloudKit

struct ChecklistItem {

    let key: String         // Unique string used by device (eg. RearAwning)
    let name: String        // Human readable Title
    let tripMode: TripMode  // "category" TripMode.rawValue
    let description: String //
    var sortOrder: Int      //
    var photoData: Data?    //
    var isDone: Bool        //
    var date: Date?         //

    init(key: String,
         name: String,
         category: TripMode,
         description: String,
         sortOrder: Int,
         photoData: Data? = nil,
         isDone: Bool = false) {
        self.key = key
        self.name = name
        self.tripMode = category
        self.description = description
        self.sortOrder = sortOrder
        self.photoData = photoData
        self.isDone = isDone
    }
    
    init?(from record: CKRecord) {
        guard
            let name = record["name"] as? String,
            let category = TripMode(rawValue: record["tripMode"] as? String ?? "Pre-Trip"),
            let description = record["description"] as? String,
            let sortOrder = record["sortOrder"] as? Int
        else { return nil }
        let key = record.recordID.recordName
        let photoData = record["photoData"] as? Data
        let isDone = record["isDone"] as? Bool
        self = .init(key: key,
                  name: name,
                  category: category,
                  description: description,
                  sortOrder: sortOrder,
                  photoData: photoData,
                  isDone: isDone ?? false)
    }
}

extension ChecklistItem: Equatable {
    static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
        return lhs.key == rhs.key
    }
}

extension ChecklistItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}
