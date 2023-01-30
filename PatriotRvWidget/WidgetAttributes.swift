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
        var rvAmps: Int
        var teslaAmps: Int
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

