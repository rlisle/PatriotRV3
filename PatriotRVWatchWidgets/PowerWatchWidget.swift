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
