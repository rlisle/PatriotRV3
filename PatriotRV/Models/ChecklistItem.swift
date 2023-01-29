//
//  ChecklistItem.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/12/21.
//

import SwiftUI

struct ChecklistItem {

    let id: String          // Used by device (eg. RearAwning) MQTT status
    let name: String        // Title
    let category: String    // Pre-Trip, Departure, Arrival
    let order: Int          // Display sort order
    let description: String // Markdown?
    var isDone: Bool = false {
        didSet {
            if oldValue != isDone {
                mqtt?.publish(topic: "patriot/\(id)", message: isDone ? "100" : "0")
                date = Date()
            }
        }
    }
    var imageName: String?
    var date: Date?         // Either completion or due date

    weak var mqtt: MQTTManagerProtocol?

    init(id: String, name: String, category: String, order: Int, description: String, imageName: String? = nil) {
        self.id = id
        self.name = name
        self.category = category
        self.order = order
        self.description = description
        self.imageName = imageName
        isDone = false
    }
}

extension ChecklistItem: Identifiable {
    static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
        return lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.category == rhs.category
    }
}

extension ChecklistItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(category)
    }
}
