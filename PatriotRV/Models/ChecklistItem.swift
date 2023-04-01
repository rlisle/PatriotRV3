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

    let key: String         // (CD_entityName STRING) Used by device (eg. RearAwning) MQTT status, unique
    let name: String        // (CD_title STRING) Title
    let tripMode: TripMode  // (CD_category STRING)
    let description: String // (CD_instructions STRING)
    var sortOrder: Int      // (CD_sequence INT(64))
    var imageName: String?  // (CD_photoData BYTES)
    var isDone: Bool        // (CD_isDone INT(64))
    var date: Date?         // (CD_timestamp DATE/TIME) Either completion or due date ?

    init(key: String,
         name: String,
         category: TripMode,
         description: String,
         sortOrder: Int,
         imageName: String? = nil,
         isDone: Bool = false) {
        self.key = key
        self.name = name
        self.tripMode = category
        self.description = description
        self.sortOrder = sortOrder
        self.imageName = imageName
        self.isDone = isDone
    }
    
    init?(from record: CKRecord) {
        guard
            let key = record["key"] as? String,
            let name = record["name"] as? String,
            let category = TripMode(rawValue: record["tripMode"] as? String ?? "Pre-Trip"),
            let description = record["description"] as? String,
            let sortOrder = record["sortOrder"] as? Int
        else { return nil }
        let imageName = record["imageName"] as? String
        let isDone = record["isDone"] as? Bool
        self = .init(key: key,
                  name: name,
                  category: category,
                  description: description,
                  sortOrder: sortOrder,
                  imageName: imageName,
                  isDone: isDone ?? false)
    }
}

extension ChecklistItem: Equatable {
    static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
        return lhs.key == rhs.key
        && lhs.name == rhs.name
        && lhs.tripMode == rhs.tripMode
    }
}

extension ChecklistItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(name)
        hasher.combine(tripMode)
    }
}
