//
//  PowerWatchWidget.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/25/23.
//

import WidgetKit
import SwiftUI
import Intents


struct PowerWatchWidgetEntryView : View {
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
            
        default:
            //Color("WidgetBackground")
            VStack(alignment: .leading) {
                HStack {
                    Text("Amps:").font(.caption)
                }
                HStack {
                    Text("RV:").font(.caption)
                    Gauge(value: Double(entry.rvAmps), in: 0...50) {
                        Text("n/a")
                    } currentValueLabel: {
                        Text("n/a")
                    } minimumValueLabel: {
                        Text("0").font(.headline)
                    } maximumValueLabel: {
                        Text("50").font(.caption)
                    }
                }
                HStack {
                    Text("Tesla:")
                    Gauge(value: Double(entry.teslaAmps), in: 0...50) {
                        Text("Not displayed")
                    } currentValueLabel: {
                        Text("RV").font(.title)
                    } minimumValueLabel: {
                        Text("0").font(.caption)
                    } maximumValueLabel: {
                        Text("50").font(.caption)
                    }
                    .gaugeStyle(.linear)
                }
            }
        }
    }
}

struct PowerWatchWidget: Widget {
    let kind: String = Constants.powerKind
    
    let accessories: [WidgetFamily] = [.accessoryRectangular, .accessoryInline, .accessoryCircular, .accessoryCorner]
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: PowerProvider()) { entry in
            PowerWatchWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("RV Power")
        .description("RV Power")
        .supportedFamilies(accessories)
    }
}

struct PowerWatchWidget_Previews: PreviewProvider {
    
    static let watchFamilies: [WidgetFamily] = [.accessoryRectangular, .accessoryInline, .accessoryCircular, .accessoryCorner]

    static var previews: some View {
        Group {
            ForEach(watchFamilies,
                id: \.self) { family in
                
                PowerWatchWidgetEntryView(
                    entry: PowerEntry(
                        rvAmps: 7,
                        teslaAmps: 24))
                .previewContext(WidgetPreviewContext(family: family))
                .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 5 (44 mm)"))
                .previewDisplayName(String(family.description.dropFirst(9)))
            }
        }
    }
}
