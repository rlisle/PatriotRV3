//
//  PowerView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 1/22/23.
//

import SwiftUI

struct PowerView: View {

    @EnvironmentObject var modelData: ModelData

    @State private var rv = 5.0
    @State var tesla = 30.0
    
    var body: some View {
        VStack {
            Text("Power Usage")
            HStack {
                VStack {
                    Gauge(value: rv, in: 0...50) {
                        Text("RV")
                    } currentValueLabel: {
                        Text("\(rv)")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("50")
                    }
                    //.gaugeStyle(.accessoryCircular)
                    .gaugeStyle(.accessoryLinearCapacity)
                    
                    Gauge(value: tesla, in: 0...50) {
                        Text("Tesla")
                    } currentValueLabel: {
                        Text("\(tesla)")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("50")
                    }
                    //.gaugeStyle(.accessoryCircular)
                    .gaugeStyle(.accessoryLinearCapacity)
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
    }
}
