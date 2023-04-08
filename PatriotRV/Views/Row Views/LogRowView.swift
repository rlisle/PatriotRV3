//
//  LogRowView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/17/23.
//

import SwiftUI

struct LogRowView: View {
    var body: some View {
        Text("Log")
    }
}

struct LogRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            LogRowView()
                .environmentObject(ViewModel(mqttManager: MockMQTTManager()))
        }
        .modifier(PreviewDevices())
    }
}
