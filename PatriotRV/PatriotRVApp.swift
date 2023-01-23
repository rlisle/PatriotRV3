//
//  PatriotRVApp.swift
//  PatriotRV
//
//  Created by Ron Lisle on 1/21/23.
//

import SwiftUI

@main
struct PatriotRVApp: App {
    
    @StateObject private var modelData = ModelData(mqttManager: MQTTManager())

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(modelData)
        }
    }
}
