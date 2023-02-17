//
//  PowerRowView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/17/23.
//

import SwiftUI

struct PowerRowView: View {
    var body: some View {
        VStack {
            Text("Power")
            RvPowerView()
            TeslaPowerView()
        }
    }
}

struct PowerRowView_Previews: PreviewProvider {
    static var previews: some View {
        PowerRowView()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Power Row")
            .environmentObject(ModelData(mqttManager: MockMQTTManager()))
    }
}
