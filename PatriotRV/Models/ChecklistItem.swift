//
//  ChecklistItem.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/12/21.
//

import SwiftUI

struct ChecklistItem {

    var id: Int             // Todo and display sort order (1 - #items)
    let key: String         // Used by device (eg. RearAwning) MQTT status    let key: String
    let name: String        // Title
    let tripMode: TripMode
    let description: String // Markdown?
    var isDone: Bool = false {
        didSet {
            delegate?.publish(id: id, isDone: isDone)
            date = Date()
        }
    }
    var imageName: String?
    var date: Date?         // Either completion or due date

    weak var delegate: Publishing?

    init(id: Int, key: String, name: String, category: TripMode, description: String, imageName: String? = nil, isDone: Bool = false) {
        self.id = id
        self.key = key
        self.name = name
        self.tripMode = category
        self.description = description
        self.imageName = imageName
        self.isDone = isDone
    }
    
    mutating func setDone(_ done: Bool) {
        isDone = done
    }
}

extension ChecklistItem: Identifiable {
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
