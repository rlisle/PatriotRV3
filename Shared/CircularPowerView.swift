//
//  CircularPowerView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/25/23.
//

import SwiftUI

struct CircularPowerView: View {

    var tripMode: String
    var doneCount: Int
    var totalCount: Int

    var body: some View {
        VStack {
            Gauge(value: 3, in: 0...13) {
                Text("Not displayed")
            } currentValueLabel: {
                Text(tripMode).font(.title)
            } minimumValueLabel: {
                Text(String(doneCount)).font(.caption)
            } maximumValueLabel: {
                Text(String(totalCount)).font(.caption)
            }
            .gaugeStyle(.accessoryCircular)
        }
    }
}
