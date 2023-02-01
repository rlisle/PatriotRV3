//
//  Trip.swift
//  PatriotRV
//
//  This model represents a planned or previous trip
//
//  Created by Ron Lisle on 2/1/23.
//

import Foundation

struct Trip  {
    let date: Date
    let destination: String
    let notes: String?
    let address: String?
    let imageName: String?
    let category: TripMode
    let sequence: Int
    let isDone: Bool
    let website: String?
}

extension Trip: Equatable {
    static func ==(lhs: Trip, rhs: Trip) -> Bool {
        return lhs.destination == rhs.destination
        && lhs.date == rhs.date
    }
}

extension Trip: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(destination)
        hasher.combine(date)
    }
}

