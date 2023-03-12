//
//  PowerWidget.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/25/23.
//

import WidgetKit
import SwiftUI
import Intents


struct PowerWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    
    var entry: PowerProvider.Entry

    var body: some View {
        
        switch family {
        case .accessoryInline:      // Lock screen only
            Text("RV: \(entry.rvAmps), Tesla: \(entry.teslaAmps)")

        default:
            ZStack {
                //Color("WidgetBackground")
                VStack(alignment: .leading) {
                    HStack {
                        Text("RV Amps:")
                        Spacer()
                        Text("\(entry.rvAmps)")
                    }
                    HStack {
                        Text("Tesla Amps:")
                        Spacer()
                        Text("\(entry.teslaAmps)")
                    }
                }
                .padding(8)
            }
        }
    }
}

struct PowerWidget: Widget {
    let kind: String = Constants.powerKind
    
    static let accessories: [WidgetFamily] = [
        .accessoryRectangular,
        .accessoryInline,
        .systemSmall
    ]
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: PowerProvider()) { entry in
            PowerWidgetEntryView(entry: entry)
                .widgetURL(URL(string: "patriot:///power")!)
        }
        .configurationDisplayName("Power Monitor")
        .description("RV & Tesla Power Monitor")
        .supportedFamilies(PowerWidget.accessories)
    }
}

struct PowerWidget_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ForEach(PowerWidget.accessories,
                id: \.self) { family in
                let accessory = family.description.hasPrefix("accessory")
                let numToDrop = accessory ? 9 : 6

                PowerWidgetEntryView(
                    entry: PowerEntry(
                        rvAmps: 4,
                        teslaAmps: 24))
                .previewContext(WidgetPreviewContext(family: family))
                .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
                .previewDisplayName(String(family.description.dropFirst(numToDrop)))
            }
        }
    }
}
