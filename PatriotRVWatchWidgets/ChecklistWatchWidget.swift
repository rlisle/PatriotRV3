//
//  PatriotRvWatchWidget.swift
//  PatriotRvWatchWidget
//
//  Created by Ron Lisle on 1/25/23.
//

import WidgetKit
import SwiftUI
import Intents


struct ChecklistWatchWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    
    var entry: Provider.Entry

    var body: some View {
        
        switch family {
        case .accessoryCircular:
            Gauge(value: 3, in: 0...13) {
                Text("Not displayed")
            } currentValueLabel: {
                Text(entry.tripMode).font(.title)
            } minimumValueLabel: {
                Text(String(entry.doneCount)).font(.caption)
            } maximumValueLabel: {
                Text(String(entry.totalCount)).font(.caption)
            }
            .gaugeStyle(.accessoryCircular)

        case .accessoryInline:
            Text("\(entry.nextTrip): \(entry.tripMode) \(entry.doneCount) of \(entry.totalCount)")
            
        default:
            ZStack {
                //Color("WidgetBackground")
                VStack(alignment: .leading) {
                    Link(destination: URL(string: "patriot:///link1")!, label: {
                        HStack {
                            Text("Trip: ")
                            Spacer()
                            Text(entry.nextTrip)
                        }
                    })
                    Link(destination: URL(string: "patriot:///link2")!, label: {
                        HStack {
                            Text(entry.tripMode)
                            Spacer()
                            Text("\(entry.doneCount) of \(entry.totalCount)")
                        }
                    })
                    Link(destination: URL(string: "patriot:///link3")!, label: {
                        HStack {
                            Text("Next: ")
                            Spacer()
                            Text(entry.nextItem)
                        }
                    })
                }
                .padding(8)
            }
        }
    }
}

struct ChecklistWatchWidget: Widget {
    let kind: String = Constants.checklistKind
    
    let accessories: [WidgetFamily] = [.accessoryRectangular, .accessoryInline, .accessoryCircular, .accessoryCorner]
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: Provider()) { entry in
            ChecklistWatchWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("RV Checklist")
        .description("RV Trip Checklist")
        .supportedFamilies(accessories)
    }
}

struct ChecklistWatchWidget_Previews: PreviewProvider {
    
    static let families: [WidgetFamily] = [.accessoryRectangular, .accessoryInline, .accessoryCircular, .accessoryCorner]

    static var previews: some View {
        Group {
            ForEach(families,
                id: \.self) { family in
                
                ChecklistWatchWidgetEntryView(
                    entry: ChecklistEntry(
                        nextTrip: "Canada",
                        tripMode: "Parked",
                        doneCount: 3,
                        totalCount: 15,
                        nextItem: "Plan Trip"))
                .previewContext(WidgetPreviewContext(family: family))
                .previewDisplayName(String(family.description.dropFirst(9)))
            }
        }
    }
}
