//
//  Trips.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/3/23.
//

import Foundation

extension ViewModel {
    
    func nextTrip(date: Date?) -> Trip? {
        let today = date ?? Date()
        let tripsAfterDate = trips.filter { $0.date >= today }
        return tripsAfterDate.first
    }
    
    static let initialTrips = [
        Trip(
            date: Date("07/26/22"),
            destination: "Wildwood RV and Golf Resort",
            notes: "Summer location, near Windsor, ON",
            address: "11112 11th Concession Rd, McGregor, ON NOR 1JO",
            website: "https://www.wildwoodgolfandrvresort.com",
            photoData: nil),

        Trip(
            date: Date("10/31/22"),
            destination: "Halloween",
            notes: "Test trip for unit tests",
            address: "1234 Test Rd, Testville, TX",
            website: "https://www.wildwoodgolfandrvresort.com",
        photoData: nil),

        Trip(
            date: Date("02/03/23"),
            destination: "Hampton Inn, Rockport",
            notes: "Checking out HEB RV sites",
            address: "3677 IH35 Rockport, TX 78382",
            website: "https://www.hilton.com/en/hotels/rpttxhx-hampton-suites-rockport-fulton/",
        photoData: nil),

        Trip(
            date: Date("06/24/23"),
            destination: "Wildwood RV and Golf Resort",
            notes: "Summer location, near Windsor, ON. Leave after baby born. Arrive before 4th of July traffic.",
            address: "11112 11th Concession Rd, McGregor, ON NOR 1JO",
            website: "https://www.wildwoodgolfandrvresort.com",
            photoData: nil),
        ]
    
    func seedTrips() {
        trips = ViewModel.initialTrips
        // Don't save when mockData is true
//        persistTrips()
//        saveTrips()
    }

    // Share trips to UserDefaults for use by widgets, etc.
    func persistTrips() {
        if let trip = nextTrip(date: Date()) {
            UserDefaults(suiteName: "group.net.lisles.patriotrv")!.setValue(trip.destination, forKey: "NextTrip")
        }
    }
    
    func addTrip(_ trip: Trip) {
        trips.append(trip)
    }
}
