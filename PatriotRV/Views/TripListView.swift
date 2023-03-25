//
//  TripListView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/1/23.
//

import SwiftUI

struct TripListView: View {
    @EnvironmentObject var model: ViewModel

    var body: some View {
        //TODO:
        VStack {
            if let trip = model.trips.last {
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

struct TripListView_Previews: PreviewProvider {
    static var previews: some View {
        TripListView()
            .environmentObject(ViewModel(mqttManager: MockMQTTManager()))
    }
}
