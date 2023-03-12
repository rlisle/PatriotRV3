//
//  UserDefaultsExtension.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/25/23.
//

import Foundation

extension UserDefaults {
    static let group = UserDefaults(suiteName: "group.net.lisles.patriotrv")!
    enum Keys: String {
        case nextTrip = "NextTrip"
        case tripMode = "TripMode"
        case doneCount = "DoneCount"
        case totalCount = "TotalCount"
        case nextItem = "NextItem"
        case rvAmps = "RvAmps"
        case teslaAmps = "TeslaAmps"
    }
}
