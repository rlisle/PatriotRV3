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
    
    func nextChecklistItem() -> ChecklistItem? {
        return(checklist.first)
    }
    
    func initializeTrips() {
        // Load trips (for now hardcode a few)
        trips.append(Trip(
            date: Date("07/26/22"),
            destination: "Wildwood RV and Golf Resort",
            notes: "Summer location, near Windsor, ON",
            address: "11112 11th Concession Rd, McGregor, ON NOR 1JO",
            imageName: nil,
            website: "https://www.wildwoodgolfandrvresort.com"))
        
        trips.append(Trip(
            date: Date("10/31/22"),
            destination: "Halloween",
            notes: "Test trip for unit tests",
            address: "1234 Test Rd, Testville, TX",
            imageName: nil,
            website: "https://www.wildwoodgolfandrvresort.com"))
        
        trips.append(Trip(
            date: Date("02/03/23"),
            destination: "Hampton Inn, Rockport",
            notes: "Checking out HEB RV sites",
            address: "3677 IH35 Rockport, TX 78382",
            imageName: nil,
            website: "https://www.hilton.com/en/hotels/rpttxhx-hampton-suites-rockport-fulton/"))

    }
}
