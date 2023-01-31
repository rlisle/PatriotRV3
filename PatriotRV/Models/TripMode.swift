//
//  TripMode.swift
//  PatriotRV
//
//  Created by Ron Lisle on 1/31/23.
//

import Foundation

enum TripMode: String, Codable {
    case parked = "Parked"
    case maintenance = "Maintenance"
    case pretrip = "Pre-Trip"
    case departure = "Departure"
    case reststop = "Rest-Stop"
    case arrival = "Arrival"
}
