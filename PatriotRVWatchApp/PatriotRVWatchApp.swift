//
//  PatriotRVWatchApp.swift
//  PatriotRVWatch Watch App
//
//  Created by Ron Lisle on 1/21/23.
//

import SwiftUI

@main
struct PatriotRVWatchApp: App {
    
    @StateObject private var model = WatchModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
