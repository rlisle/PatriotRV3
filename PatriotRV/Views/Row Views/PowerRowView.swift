//
//  PowerRowView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/17/23.
//

import SwiftUI

struct PowerRowView: View {
    
    @EnvironmentObject var model: ModelData
    
    var font: Font = .title
    
    var body: some View {
        VStack {
            PowerGaugeView(title: "Power Usage", value: model.rv, font: font)
        }
    }
}

struct PowerRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PowerRowView()
                .environmentObject(ModelData())
        }
    }
}
