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
                            .bold()
                        Spacer()
                        Text(model.nextTripDate?.mmddyy() ?? "?")
                            .bold()
                    }
                    
                    Text(model.nextTrip)
                        .font(.system(size: 500))
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        .padding(.bottom, 16)
                    
                    HStack {
                        Text(model.phase.rawValue)
                        Text("next Item: ")
                        Spacer()
                    }
                    .bold()
                    HStack {
                        Text(model.nextItem)
                        .font(.system(size: 500))
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
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
