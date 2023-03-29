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
    
    var entry: ChecklistProvider.Entry

    var body: some View {
        
        switch family {
        case .accessoryCircular:
            Gauge(value: Float(entry.doneCount), in: 0...Float(entry.totalCount)) {
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
            VStack(alignment: .leading) {
                HStack {
                    Link(destination: URL(string: "patriot:///trip")!, label: {
                        Text("Trip: ")
                        Spacer()
                        Text(entry.nextTrip)
                    })
                }
                Spacer()
                HStack {
                    Link(destination: URL(string: "patriot:///tripmode")!, label: {
                        Text(entry.tripMode)
                        Spacer()
                        Text("\(entry.doneCount) of \(entry.totalCount)")
                    })
                }
                HStack {
                    Link(destination: URL(string: "patriot:///nextitem")!, label: {
                        Text("Next: ")
                        Spacer()
                        Text(entry.nextItem)
                    })
                }
            }
            .background(Image("truck-rv").opacity(0.2).scaledToFill())
            .foregroundColor(.black)
            .padding(8)
        }
    }
}

struct ChecklistWidget: Widget {
    let kind: String = Constants.checklistKind
    
    static let accessories: [WidgetFamily] = [
        .accessoryInline,
        .accessoryCircular,
        .systemMedium,
        .systemSmall
    ]
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: ChecklistProvider()) { entry in
            ChecklistWidgetEntryView(entry: entry)
                .widgetURL(URL(string: "patriot:///list")!)
        }
        .configurationDisplayName("RV Checklist")
        .description("RV Trip Checklist")
        .supportedFamilies(ChecklistWidget.accessories)
    }
}

struct ChecklistWidget_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ForEach(ChecklistWidget.accessories,
                id: \.self) { family in
                let accessory = family.description.hasPrefix("accessory")
                let numToDrop = accessory ? 9 : 6

                ChecklistWidgetEntryView(
                    entry: ChecklistEntry(
                        nextTrip: "Canada",
                        tripMode: "Parked",
                        doneCount: 3,
                        totalCount: 15,
                        nextItem: "Plan Trip"))
                .previewContext(WidgetPreviewContext(family: family))
                .previewDisplayName(String(family.description.dropFirst(numToDrop)))
            }
        }
    }
}
