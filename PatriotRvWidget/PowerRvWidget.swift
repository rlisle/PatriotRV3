//
//  PowerRvWidget.swift
//  PatriotRvWidgetExtension
//
//  Created by Ron Lisle on 3/11/23.
//
import WidgetKit
import SwiftUI
import Intents

struct PowerRvWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    
    var entry: PowerProvider.Entry

    var body: some View {
        
        switch family {
        case .accessoryCircular:    // Lock screen only
            CircularView(title: "RV",
                         value: entry.rvAmps,
                         total: 50)

        case .accessoryInline:      // Lock screen only
            Text("RV: \(entry.rvAmps) amps")

        default:
            ZStack {
                //Color("WidgetBackground")
                VStack(alignment: .leading) {
                    HStack {
                        Text("RV Amps:")
                        Spacer()
                        Text("\(entry.rvAmps)")
                    }
                }
                .padding(8)
            }
        }
    }
}

struct PowerRvWidget: Widget {
    let kind: String = Constants.powerKind
    
    static let accessories: [WidgetFamily] = [
        .accessoryRectangular,  // Lock screen only
        .accessoryInline,       // Lock screen only
        .accessoryCircular,     // Lock screen only
        .systemSmall
    ]
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: PowerProvider()) { entry in
            PowerRvWidgetEntryView(entry: entry)
                .widgetURL(URL(string: "patriot:///power")!)
        }
        .configurationDisplayName("RV Power Monitor")
        .description("RV Power Monitor")
        .supportedFamilies(PowerWidget.accessories)
    }
}

struct PowerRvWidget_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ForEach(PowerRvWidget.accessories,
                id: \.self) { family in
                let accessory = family.description.hasPrefix("accessory")
                let numToDrop = accessory ? 9 : 6

                PowerRvWidgetEntryView(
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
