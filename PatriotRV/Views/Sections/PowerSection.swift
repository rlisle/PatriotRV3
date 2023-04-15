//
//  PowerSection.swift
//  PatriotRV
//
//  Created by Ron Lisle on 4/15/23.
//

import SwiftUI

struct PowerSection: View {
    var body: some View {
        Section {
            NavigationLink(value: "power") {
                PowerRowView(font: .body)
            }
        } header: {
            Text("Power")
        }
    }
}

struct PowerSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PowerSection()
        }
        .previewLayout(.fixed(width: 640, height: 60))
    }
}
