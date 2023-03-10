//
//  ChecklistEntry.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/25/23.
//

import Foundation
import WidgetKit
import Intents

struct ChecklistEntry: TimelineEntry {
    let date = Date()
    let nextTrip: String
    let tripMode: String
    let doneCount: Int
    let totalCount: Int
    let nextItem: String
}
