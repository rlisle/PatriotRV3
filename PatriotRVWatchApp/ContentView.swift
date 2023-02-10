//
//  ContentView.swift
//  PatriotRVWatch Watch App
//
//  Created by Ron Lisle on 1/21/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var path: [String] = []  // ???
    
    var body: some View {
        NavigationStack {
            HStack {
                Text("Next trip: ")
                Spacer()
            }
            List {
                NavigationLink("Checklist", value: "checklist")
                NavigationLink("Lights", value: "lights")
                NavigationLink("Power", value: "power")
            }
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "checklist":
                    ChecklistView()
                case "lights":
                    LightsView()
                default:
                    PowerView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
