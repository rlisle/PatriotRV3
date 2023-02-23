//
//  ContentView.swift
//  PatriotRVWatch Watch App
//
//  Created by Ron Lisle on 1/21/23.
//

import SwiftUI

struct WatchHome: View {
    
    @EnvironmentObject var model: WatchModel

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Next trip: ")
                        .font(.caption2)
                    Text(model.nextTrip)
                        .font(.headline)
                    Spacer()
                    Text(model.nextTripDate?.mmddyy() ?? "?")
                        .font(.caption2)
                }
                HStack {
                    Text("Trip Phase: ")
                    Spacer()
                    Text(model.phase.rawValue)
                }
                HStack {
                    Text("Next: ")
                    Spacer()
                    Text(model.nextItem)
                }
            }
            .background(
                Image("truck-rv")
//                    .resizable()
            )
        }
    }
}

struct WatchHome_Previews: PreviewProvider {
    static var previews: some View {
        WatchHome()
            .environmentObject(WatchModel())
    }
}
