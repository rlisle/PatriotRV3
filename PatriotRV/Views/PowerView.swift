//
//  PowerView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 1/22/23.
//

import SwiftUI

struct PowerView: View {

    @EnvironmentObject var modelData: ModelData

    @State private var current = 5.0
    
    var body: some View {
        VStack {
            Text("RV Power Usage")
            Gauge(value: current, in: 0...50) {
                Text("Amps")
            } currentValueLabel: {
                Text("\(Int(current))")
            }
            .gaugeStyle(.accessoryCircular)
            .padding(.horizontal, 32)
        }
        .navigationTitle("Power Usage")
        .blackNavigation
    }
}

struct PowerView_Previews: PreviewProvider {
    static var previews: some View {
        PowerView()
    }
}
