//
//  TripView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 4/3/23.
//

import SwiftUI

struct TripView: View {
    @EnvironmentObject var model: ViewModel
    
    let trip: Trip?
    
    var body: some View {
        VStack {
            if let trip = trip {
                Text("Date: \(trip.date.mmddyy())")
                Text("Destination: \(trip.destination)")
                if let notes = trip.notes {
                    Text("Notes: \(notes)")
                }
            } else {
                Text("No trips")
            }
        }
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView(trip: Mock.trip)
            .environmentObject(ViewModel(mqttManager: MockMQTTManager()))
            .modifier(PreviewDevices())
    }
}

