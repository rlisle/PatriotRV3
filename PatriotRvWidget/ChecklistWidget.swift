//
//  PatriotRvWidget.swift
//  PatriotRvWidget
//
//  Created by Ron Lisle on 1/25/23.
//

import WidgetKit
import SwiftUI
import Intents


struct ChecklistWidgetEntryView : View {
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
            
        case .systemLarge:
                VStack(alignment: .leading) {
                    HStack {
                        Link(destination: URL(string: "patriot:///link1")!, label: {
                            Text("Trip: ")
                            Spacer()
                            Text(entry.nextTrip)
                        })
                    }
                    Spacer()
                    HStack {
                        Link(destination: URL(string: "patriot:///link2")!, label: {
                            Text(entry.tripMode)
                            Spacer()
                            Text("\(entry.doneCount) of \(entry.totalCount)")
                        })
                    }
                    HStack {
                        Link(destination: URL(string: "patriot:///link3")!, label: {
                            Text("Next: ")
                            Spacer()
                            Text(entry.nextItem)
                        })
                    }
                }
                .background(Image("truck-rv"))
                .padding(8)
            
        case .accessoryCorner:
            ZStack {
                Image(systemName: "checkmark.square")
//                widgetLabel("\(entry.nextTrip): \(entry.tripMode) \(entry.doneCount) of \(entry.totalCount)")
            }

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

struct ChecklistWidget: Widget {
    let kind: String = Constants.checklistKind
    
    #if os(watchOS)
    let accessories: [WidgetFamily] = [.accessoryRectangular, .accessoryInline, .accessoryCircular, .accessoryCorner]
    #else
    let accessories: [WidgetFamily] = [.accessoryRectangular, .accessoryInline, .accessoryCircular, .systemLarge, .systemMedium, .systemSmall]
    #endif
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: Provider()) { entry in
            ChecklistWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("RV Checklist")
        .description("RV Trip Checklist")
        .supportedFamilies(accessories)
    }
}

struct ChecklistWidget_Previews: PreviewProvider {
    
    #if os(watchOS)
    static let families: [WidgetFamily] = [.accessoryRectangular, .accessoryInline, .accessoryCircular, .accessoryCorner]
    #else
    static let families: [WidgetFamily] = [.accessoryRectangular, .accessoryInline, .accessoryCircular, .systemLarge, .systemMedium, .systemSmall]
    #endif

    static var previews: some View {
        Group {
            ForEach(families,
                id: \.self) { family in
                
                ChecklistWidgetEntryView(
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
