//
//  PatriotRvWidget.swift
//  PatriotRvWidget
//
//  Created by Ron Lisle on 1/25/23.
//

import WidgetKit
import SwiftUI
import Intents


// This is the Widget View
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
            
        #if !os(watchOS)
        case .systemLarge:
                VStack(alignment: .leading) {
                    HStack {
                        Text("Trip: ")
                        Spacer()
                        Text(entry.nextTrip)
                    }
                    HStack {
                        Text(entry.tripMode)
                        Spacer()
                        Text("\(entry.doneCount) of \(entry.totalCount)")
                    }
                    HStack {
                        Text("Next: ")
                        Spacer()
                        Text(entry.nextItem)
                    }
                }
                .background(Image("truck-rv"))
                .padding(8)
            #endif

        default:
            ZStack {
                //Color("WidgetBackground")
                VStack(alignment: .leading) {
                    HStack {
                        Text("Trip: ")
                        Spacer()
                        Text(entry.nextTrip)
                    }
                    HStack {
                        Text(entry.tripMode)
                        Spacer()
                        Text("\(entry.doneCount) of \(entry.totalCount)")
                    }
                    HStack {
                        Text("Next: ")
                        Spacer()
                        Text(entry.nextItem)
                    }
                }
                .padding(8)
            }
        }
    }
}

struct ChecklistWidget: Widget {
    let kind: String = Constants.kind
    
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
    
    static var previews: some View {
        //TODO: use a foreach WidgetFamiliy (doesn't seem to work)
        Group {
            
            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    doneCount: 3,
                    totalCount: 15,
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .previewDisplayName("Circular")
            
            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    doneCount: 3,
                    totalCount: 15,
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
            .previewDisplayName("Inline")
            
            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    doneCount: 3,
                    totalCount: 15,
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .previewDisplayName("Rectangular")
            
            #if !os(watchOS)
            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    doneCount: 3,
                    totalCount: 15,
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small")

            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    doneCount: 3,
                    totalCount: 15,
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Medium")

            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    doneCount: 3,
                    totalCount: 15,
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .previewDisplayName("Large")

            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    doneCount: 3,
                    totalCount: 15,
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
            .previewDisplayName("ExtraLarge")
            #endif
        }
    }
}
