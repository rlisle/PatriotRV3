//
//  Trip.swift
//  PatriotRV
//
//  This model represents a planned or previous trip
//  The CKRecord.ID is = date+destination
//
//  Created by Ron Lisle on 2/1/23.
//

import Foundation
import CloudKit
import PhotosUI

struct Trip  {
    let date: Date
    let destination: String
    let notes: String?
    let address: String?
    let imageName: String?
    let website: String?
    
    private var photoData: Data?
    
    init(date: Date,
        destination: String,
        notes: String?,
        address: String?,
        imageName: String?,
        website: String?,
        photoData: Data? = nil
    ) {
        self.date = date
        self.destination = destination
        self.notes = notes
        self.address = address
        self.imageName = imageName
        self.website = website
        self.photoData = photoData
    }
    
    init?(from record: CKRecord) {
        guard
            let date = record["date"] as? Date,
            let destination = record["destination"] as? String
        else { return nil }
        let notes = record["notes"] as? String
        let address = record["address"] as? String
        let imageName = record["imageName"] as? String
        let website = record["website"] as? String
        self = .init(
            date: date,
            destination: destination,
            notes: notes,
            address: address,
            imageName: imageName,
            website: website
        )
    }
    
    func isWithin2weeks(today: Date) -> Bool {
        guard let twoWeeksFromToday = Calendar.current.date(byAdding: .weekOfYear, value: 2, to: today) else {
            return false
        }
        return date <= twoWeeksFromToday
    }
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
