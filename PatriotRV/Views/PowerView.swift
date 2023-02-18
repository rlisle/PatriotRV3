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
                    RvPowerView()
                        .padding(.vertical, 8)
                    TeslaPowerView()
                }
            }
            .padding(.horizontal, 32)
        }
        .navigationTitle("Power Usage")
        .blackNavigation
    }
}

struct RvPowerView: View {

    @EnvironmentObject var model: ModelData

    var body: some View {
        VStack {
            Gauge(value: model.rv, in: 0...50) {
                Text("RV").font(.caption)
            } currentValueLabel: {
                Text("\(model.rv, specifier: "%.1f")").font(.title)
            } minimumValueLabel: {
                Text("0").font(.caption)
            } maximumValueLabel: {
                Text("50").font(.caption)
            }
            .gaugeStyle(.accessoryLinearCapacity)
            .tint(model.rvTint)
        }
    }
}

struct TeslaPowerView: View {

    @EnvironmentObject var model: ModelData

    var body: some View {
        VStack {
            Gauge(value: model.tesla, in: 0...50) {
                Text("Tesla").font(.caption)
            } currentValueLabel: {
                Text("\(model.tesla, specifier: "%.1f")").font(.title)
            } minimumValueLabel: {
                Text("0").font(.caption)
            } maximumValueLabel: {
                Text("50").font(.caption)
            }
            .gaugeStyle(.accessoryLinearCapacity)
            .tint(model.teslaTint)
        }
    }
}

struct PowerView_Previews: PreviewProvider {
    static var previews: some View {
        PowerView()
            .environmentObject(ModelData())
    }
}
