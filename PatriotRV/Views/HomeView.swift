//
//  HomeView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 1/22/23.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var model: ModelData
    
    var body: some View {
        TabView {
            
            ChecklistView()
                //.badge()
                .tabItem {
                    Label("Checklist", systemImage: "list.clipboard")
                }
            
            PowerView()
            //.badge()
            .tabItem {
                Label("Power", systemImage: "bolt.fill")
            }

            LogView()
            //.badge()
            .tabItem {
                Label("Log", systemImage: "list.dash")
            }

        }
        .navigationTitle("Patriot RV")
        .blackNavigation
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ModelData(mqttManager: MQTTManager()))
    }
}
