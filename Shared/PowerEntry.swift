//
//  PowerEntry.swift
//  PatriotRV
//
//  Created by Ron Lisle on 3/11/23.
//

import Foundation
import WidgetKit
import Intents

struct PowerEntry: TimelineEntry {
    let date = Date()
    let rvAmps: Int
    let teslaAmps: Int
}
