//
//  WidgetAttributes.swift
//  PatriotRV
//
//  Created by Ron Lisle on 1/29/23.
//

import ActivityKit

struct PatriotRvWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        
        // Power Usage changes too frequently to be displayed realtime
        var rvAmps: Int
        var teslaAmps: Int
        
        // Checklist - changes slowly, but want to see on dynamic island
        var tripMode: TripMode
        var numberItems: Int
        var numberDone: Int
        var nextItemId: String
        var nextItemName: String    // Displayable name
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

