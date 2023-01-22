//
//  PowerView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 1/22/23.
//

import SwiftUI

struct PowerView: View {

    @EnvironmentObject var model: ModelData

    var body: some View {
        VStack {
            Text("Power Usage")
            HStack {
                VStack {
                    Gauge(value: model.power.rv, in: 0...50) {
                        Text("RV")
                    } currentValueLabel: {
                        Text(model.power.rv.formatted())
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("50")
                    }
                    .gaugeStyle(.accessoryLinearCapacity)
                    .tint(model.power.rvTint)
                    
                    Gauge(value: model.power.tesla, in: 0...50) {
                        Text("Tesla")
                    } currentValueLabel: {
                        Text(model.power.tesla.formatted())
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("50")
                    }
                    .gaugeStyle(.accessoryLinearCapacity)
                    .tint(model.power.teslaTint)
                }
            }
            .padding(.horizontal, 32)
        }
        .navigationTitle("Power Usage")
        .blackNavigation
    }
}

struct PowerView_Previews: PreviewProvider {
    static var previews: some View {
        PowerView()
            .environmentObject(ModelData(mqttManager: MQTTManager()))
    }
}
