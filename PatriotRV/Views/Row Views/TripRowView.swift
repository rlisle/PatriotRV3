//
//  TripRowView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/17/23.
//

import SwiftUI

struct TripRowView: View {
    
    @EnvironmentObject var model: ModelData
    
    var body: some View {
        if let trip = model.trips.last {
            VStack(alignment: .leading) {
                HStack {
                    Text(trip.destination)
                    Spacer()
                    Text(trip.date.mmddyy())
                }
            }
        } else {
            Text("Add a New Trip")
                .font(.headline)
        }
    }
}

struct TripRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            TripRowView()
                .environmentObject(ModelData(mqttManager: MockMQTTManager()))
        }
    }
}
