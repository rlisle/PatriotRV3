//
//  HomeView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 1/22/23.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var model: ModelData
    
    @State private var showCompleted = true
    @State private var showSettings = false

    enum Screen {
        case settings
        case power
        case checklists
        case trips
    }
    @State private var selection: Screen?
    
    var body: some View {
        NavigationStack {
            VStack {
                
                ImageHeader(imageName: "truck-rv")
                
                
                List {
                    NavigationLink {
                        PowerView()
                    } label: {
                        PowerRowView()
                    }
                    NavigationLink {
                        TripListView()
                    } label: {
                        TripRowView()
                    }
                    NavigationLink {
                        ChecklistView()
                    } label: {
                        ChecklistRowView()
                    }
                    NavigationLink {
                        LogView()
                    } label: {
                        LogRowView()
                    }
                }//list
                .padding(.top, -8)
                
                Text("\(model.checklist.count) items total")
                
            } //vstack
            .navigationTitle("Summary")
            .blackNavigation
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("RV Checklist")
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            self.showSettings.toggle()
                        }
                    }) {
                        Image(systemName: "gearshape")
                            .imageScale(.large)
                    }
                    .foregroundColor(.white)
                }
            } //toolbar
            .navigationDestination(isPresented: $showSettings,
                                   destination: {
                SettingsView()
            })
        } //navigationstack
        .task {
            model.startChecklistActivity()
        }
    } //body
}

// Row views should provide summary information
struct TripRowView: View {
    @EnvironmentObject var model: ModelData
    var body: some View {
        VStack {
            Text("Trip")
            if let trip = model.trips.last {
                Text("\(trip.date.mmddyy()) \(trip.destination)")
            }
        }
    }
}

struct PowerRowView: View {
    var body: some View {
        VStack {
            Text("Power")
            RvPowerView()
            TeslaPowerView()
        }
    }
}

struct ChecklistRowView: View {
    @EnvironmentObject var model: ModelData
    var body: some View {
        VStack {
            Text("Checklist")
            //if next item...
        }
    }
}

struct LogRowView: View {
    var body: some View {
        Text("Log")
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ModelData(mqttManager: MQTTManager()))
    }
}
