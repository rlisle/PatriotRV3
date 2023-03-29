//
//  ChecklistItem.swift
//  RvChecklist
//
//  This item should only be updated via the ModelData
//
//  Created by Ron Lisle on 2/12/21.
//

import SwiftUI

struct ChecklistItem {

    let key: String         // Used by device (eg. RearAwning) MQTT status, unique
    let name: String        // Title
    let tripMode: TripMode
    let description: String // Markdown?
    var sortOrder: Int      //
    var imageName: String?  //TODO: Add ability to add/change images
    var isDone: Bool
    var date: Date?         // Either completion or due date ?

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
