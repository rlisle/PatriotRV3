//
//  Trips.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/3/23.
//

import Foundation

extension ModelData {
    
    func nextTrip(date: Date?) -> Trip? {
        let today = date ?? Date()
        let tripsAfterDate = trips.filter { $0.date >= today }
        return tripsAfterDate.first
    }
    
    func initializeTrips() {
        // Load trips (for now hardcode a few)
        trips.append(Trip(
            date: Date("07/26/22"),
            destination: "Wildwood RV and Golf Resort",
            notes: "Summer location, near Windsor, ON",
            address: "11112 11th Concession Rd, McGregor, ON NOR 1JO",
            imageName: nil,
            category: .arrival,
            sequence: 0,
            isDone: true,
            website: "https://www.wildwoodgolfandrvresort.com"))
        
        trips.append(Trip(
            date: Date("02/03/23"),
            destination: "Hampton Inn, Rockport",
            notes: "Checking out HEB RV sites",
            address: "3677 IH35 Rockport, TX 78382",
            imageName: nil,
            category: .pretrip,
            sequence: 0,
            isDone: false,
            website: "https://www.hilton.com/en/hotels/rpttxhx-hampton-suites-rockport-fulton/"))

    }
}
