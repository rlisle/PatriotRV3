//
//  PowerEntryProvider.swift
//  PatriotRV
//
//  Created by Ron Lisle on 3/11/23.
//

import Foundation
//import Foundation
import WidgetKit
//import SwiftUI
//import Intents

struct PowerProvider: TimelineProvider {
    
    typealias Entry = PowerEntry
    
    func placeholder(in context: Context) -> PowerEntry {
        return populatedPowerEntry()
    }

    func loadString(_ key: UserDefaults.Keys) -> String {
        return UserDefaults.group.string(forKey: key.rawValue) ?? "Not found"
    }
    
    func loadInt(_ key: UserDefaults.Keys) -> Int {
        return UserDefaults.group.integer(forKey: key.rawValue)
    }

    func populatedPowerEntry() -> PowerEntry {
        var rvAmps = 0
        var teslaAmps = 0

        rvAmps = loadInt(.rvAmps)
        teslaAmps = loadInt(.teslaAmps)

        return PowerEntry(
            rvAmps: rvAmps,
            teslaAmps: teslaAmps)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (PowerEntry) -> ()) {
        
        print("Widget: getSnapshot")
        
        // Use sample data if context.isPreview == true
        completion(populatedPowerEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries = [
            populatedPowerEntry()
        ]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

