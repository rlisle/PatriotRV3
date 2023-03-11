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
        case .accessoryCircular:
            CircularView(title: "RV",
                         value: entry.rvAmps,
                         total: 50)

        case .accessoryInline:
            Text("RV: \(entry.rvAmps), Tesla: \(entry.teslaAmps)")

        case .systemLarge:
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

        case .systemSmall:
            Text("RV Power")

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
    
    let accessories: [WidgetFamily] = [.accessoryRectangular, .accessoryInline, .accessoryCircular, .systemLarge, .systemMedium, .systemSmall]
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: PowerProvider()) { entry in
            PowerWidgetEntryView(entry: entry)
                .widgetURL(URL(string: "patriot:///power")!)
        }
        .configurationDisplayName("RV Power")
        .description("RV Power Monitor")
        .supportedFamilies(accessories)
    }
}

struct PowerWidget_Previews: PreviewProvider {
    
    static let phoneFamilies: [WidgetFamily] = [.accessoryRectangular, .accessoryInline, .accessoryCircular, .systemLarge, .systemMedium, .systemSmall]

    static var previews: some View {
        Group {
            ForEach(phoneFamilies,
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
