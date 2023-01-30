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

    var body: some View {
        NavigationStack {
            
            NavigationLink(
                destination: SettingsView(),
                isActive: $showSettings) { EmptyView() }
                
                VStack {
                    
                    ImageHeader(imageName: "truck-rv")

                    List {
                        NavigationLink {
                            PowerView()
                        } label: {
                            PowerRowView()
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
                }//vstack
                    
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
                }

                
        }//navigationstack
        .task {
            model.startPowerActivity()
        }
    }//body
}

// Row views should provide summary information
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
    var body: some View {
        VStack {
            Text("Checklist")
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
