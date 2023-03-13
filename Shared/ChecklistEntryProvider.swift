//
//  ChecklistEntryProvider.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/25/23.
//

//import Foundation
import WidgetKit
//import SwiftUI
//import Intents

// ???
// Since doing away with ChecklistActivityWidget, is this still needed?
// ???

struct ChecklistProvider: TimelineProvider {
    
    typealias Entry = ChecklistEntry
    
    func placeholder(in context: Context) -> ChecklistEntry {
        return populatedChecklistEntry()
    }

    func loadString(_ key: UserDefaults.Keys) -> String {
        return UserDefaults.group.string(forKey: key.rawValue) ?? "Not found"
    }
    
    func loadInt(_ key: UserDefaults.Keys) -> Int {
        return UserDefaults.group.integer(forKey: key.rawValue)
    }

    func populatedChecklistEntry() -> ChecklistEntry {
        //TODO: persist this instead of reloading every time
        var nextTrip = "Loading..."
        var tripMode: String = TripMode.parked.rawValue
        var doneCount = 0
        var totalCount = 0
        var nextItem = "Loading..."

        nextTrip = loadString(.nextTrip)
        tripMode = loadString(.tripMode)
        doneCount = loadInt(.doneCount)
        totalCount = loadInt(.totalCount)
        nextItem = loadString(.nextItem)

        return ChecklistEntry(
           nextTrip: nextTrip,
           tripMode: tripMode,
           doneCount: doneCount,
           totalCount: totalCount,
           nextItem: nextItem)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ChecklistEntry) -> ()) {
        
        print("Widget: getSnapshot")
        
        // Use sample data if context.isPreview == true
        completion(populatedChecklistEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        print("Widget: getTimeline")
        
        let entries = [
            populatedChecklistEntry()
        ]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

