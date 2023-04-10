//
//  TripMode.swift
//  PatriotRV
//
//  Created by Ron Lisle on 1/31/23.
//

import Foundation

// An enum for checklist categories
enum TripMode: String, Codable, CaseIterable {
    case parked = "Parked"
    case maintenance = "Maintenance"
    case pretrip = "Pre-Trip"
    case departure = "Departure"
    case reststop = "Rest-Stop"
    case arrival = "Arrival"
    case done = "Done"
}
