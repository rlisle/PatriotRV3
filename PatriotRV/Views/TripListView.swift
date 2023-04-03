//
//  TripListView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/1/23.
//

import SwiftUI

struct TripListView: View {
    @EnvironmentObject var model: ViewModel
    @State private var showingAddTrip = false

    var body: some View {
        VStack {
            List {
                if(model.trips.count == 0) {
                    Text("No trips found")
                } else {
                    ForEach(model.trips, id: \.self) { trip in

                      NavigationLink(destination: TripView(trip: trip)) {
                          TripRowView(trip: trip)
                      }
                    }
                }
            }
        }
        .blackNavigation
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddTrip = true
                }) {
                    Image(systemName: "plus")
                }
                .foregroundColor(.white)
            }
        }
        .navigationDestination(isPresented: $showingAddTrip, destination: {
            AddTripView()
        })
    }
}

struct TripListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(["iPhone 14 Pro", "iPad"], id: \.self) { deviceName in
                TripListView()
                    .environmentObject(ViewModel(mqttManager: MockMQTTManager()))
            }
        }
    }
}
