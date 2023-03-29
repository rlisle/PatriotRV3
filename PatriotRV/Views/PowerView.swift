//
//  PowerView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 1/22/23.
//

import SwiftUI

struct PowerView: View {

    @EnvironmentObject var model: ViewModel

    var body: some View {
        VStack {
            Text("Power Usage")
            HStack {
                VStack {
                    PowerGaugeView(title: "RV", value: model.rv)
                        .padding(.vertical, 8)
                    PowerGaugeView(title: "Tesla", value: model.tesla)
                }
            }
            .padding(.horizontal, 32)
        }
        .navigationTitle("Power Usage")
        .blackNavigation
    }
}

struct PowerGaugeView: View {

    @EnvironmentObject var model: ViewModel
    
    var title: String
    var value: Float
    var font: Font = .title

    var body: some View {
        VStack {
            Gauge(value: value, in: 0...50) {
                Text(title).font(.caption)
            } currentValueLabel: {
                Text("\(value, specifier: "%.1f")").font(font)
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

struct PowerView_Previews: PreviewProvider {
    static var previews: some View {
        PowerView()
            .environmentObject(ViewModel())
    }
}
