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
            ZStack {
//                Image("truck-rv")
//                    .resizable()
                VStack {
                    HStack {
                        Text("Next trip: ")
                            .font(.caption2)
                        Text(model.nextTrip)
                            .font(.body)
                        Spacer()
                        Text(model.nextTripDate?.mmddyy() ?? "?")
                            .font(.caption2)
                    }
                    HStack {
                        Text(model.phase.rawValue)
                        Text("next Item: ")
                        Spacer()
                    }
                    .font(.caption)
                    HStack {
                        Text(model.nextItem)
                        Checkmark(isDone: $model.isDone)
                    }
                }
            }
//            .background(
//                Image("truck-rv")
//                    .resizable()
//            )
        }
    }
}

struct WatchHome_Previews: PreviewProvider {
    static var previews: some View {
        WatchHome()
            .environmentObject(WatchModel())
    }
}
