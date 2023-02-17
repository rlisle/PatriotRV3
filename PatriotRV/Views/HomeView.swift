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
                    Section("Next Trip") {
                        NavigationLink {
                            TripListView()
                        } label: {
                            TripRowView()
                        }
                    }
                    Section("Checklist") {
                        NavigationLink {
                            ChecklistView()
                        } label: {
                            HomeChecklistRowView()
                        }
                    }
                    Section("Power") {
                        NavigationLink {
                            PowerView()
                        } label: {
                            PowerRowView()
                        }
                    }
                    Section("Log") {
                        NavigationLink {
                            LogView()
                        } label: {
                            LogRowView()
                        }
                    }
                }
                .listStyle(.grouped)
                .padding(.top, -8)
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


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ModelData(mqttManager: MockMQTTManager()))
    }
}
