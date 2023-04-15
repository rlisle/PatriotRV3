//
//  LogSection.swift
//  PatriotRV
//
//  Created by Ron Lisle on 4/15/23.
//

import SwiftUI

struct LogSection: View {
    var body: some View {
        Section {
            NavigationLink(value: "log") {
                LogRowView()
            }
        } header: {
            Text("Log")
        }
    }
}

struct LogSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            LogSection()
        }
        .previewLayout(.fixed(width: 640, height: 60))
    }
}
