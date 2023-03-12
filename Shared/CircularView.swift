//
//  CircularPowerView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/25/23.
//

import SwiftUI

struct CircularView: View {

    var title: String
    var value: Int
    var total: Int

    var body: some View {
        VStack {
            Gauge(value: 3, in: 0...13) {
                Text("Not displayed")
            } currentValueLabel: {
                Text(title).font(.title)
            } minimumValueLabel: {
                Text(String(value)).font(.caption)
            } maximumValueLabel: {
                Text(String(total)).font(.caption)
            }
            .gaugeStyle(.accessoryCircular)
        }
    }
}
