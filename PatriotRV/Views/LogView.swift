//
//  LogView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 1/23/23.
//

import SwiftUI

struct LogView: View {
    var body: some View {
        Text("TODO: show logs")
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
            .environmentObject(ModelData(mqttManager: MockMQTTManager()))
    }
}
