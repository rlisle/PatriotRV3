//
//  PatriotRvWidget.swift
//  PatriotRvWidget
//
//  Created by Ron Lisle on 1/25/23.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> ChecklistEntry {
        ChecklistEntry(date: Date(),
//                       configuration: ConfigurationIntent(),
                       nextTrip: "Who knows?",
                       tripMode: "Parked",
                       doneCount: 0,
                       totalCount: 13,
                       nextItem: "Choose destination")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (ChecklistEntry) -> ()) {
        
        let nextTrip = UserDefaults(suiteName: "group.net.lisles.patriotrv")!.string(forKey: "NextTrip")
        let tripMode = UserDefaults(suiteName: "group.net.lisles.patriotrv")!.string(forKey: "TripMode")
        let doneCount = UserDefaults(suiteName: "group.net.lisles.patriotrv")!.integer(forKey: "doneCount")
        let totalCount = UserDefaults(suiteName: "group.net.lisles.patriotrv")!.integer(forKey: "TotalCount")
        let nextItem = UserDefaults(suiteName: "group.net.lisles.patriotrv")!.string(forKey: "NextItem")

        let entry = ChecklistEntry(date: Date(),
//                                   configuration: configuration,
                                   nextTrip: nextTrip ?? "No trip",
                                   tripMode: tripMode ?? "Parked",
                                   doneCount: doneCount,
                                   totalCount: totalCount,
                                   nextItem: nextItem ?? "None")
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries = [
            ChecklistEntry(date: Date(),
                           nextTrip: "Rockport",
                           tripMode: "Parked",
                           doneCount: 0,
                           totalCount: 13,
                           nextItem: "Plan Trip"
                          )
            ]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct ChecklistEntry: TimelineEntry {
    var date: Date
    //let configuration: ConfigurationIntent
    let nextTrip: String
    let tripMode: String
    let doneCount: Int
    let totalCount: Int
    let nextItem: String
}

// This is the Widget View
struct ChecklistWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    
    var entry: Provider.Entry

    var body: some View {
        
        switch family {
        case .accessoryCircular:
            //TODO: add counts to ChecklistEntry
            Gauge(value: 3, in: 0...13) {
                Text("Not displayed").font(.caption)
            } currentValueLabel: {
                Text(entry.tripMode).font(.title)
            } minimumValueLabel: {
                Text(String(entry.doneCount)).font(.caption)
            } maximumValueLabel: {
                Text(String(entry.totalCount)).font(.caption)
            }
            .gaugeStyle(.accessoryCircular)

        case .accessoryInline:
            Text("\(entry.nextTrip): \(entry.tripMode)")

        case .accessoryRectangular:
            VStack(alignment: .leading) {
                Text("Trip: \(entry.nextTrip)")
                Text("\(entry.tripMode): \(entry.doneCount) of \(entry.totalCount)")
                Text("Next: \(entry.nextItem)")
            }

        default:
            VStack(alignment: .leading) {
                Text("Trip: \(entry.nextTrip)")
                Text(entry.tripMode)
                Text("Next: \(entry.nextItem)")
            }
        }
    }
}

struct ChecklistWidget: Widget {
    let kind: String = "ChecklistWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ChecklistWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("RV Checklist")
        .description("RV Trip Checklist")
    }
}

struct ChecklistWidget_Previews: PreviewProvider {
    
    static var previews: some View {
        //TODO: use a foreach WidgetFamiliy (doesn't seem to work)
        Group {
            
            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    date: Date(),
                    //configuration: ConfigurationIntent(),
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    doneCount: 3,
                    totalCount: 15,
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .previewDisplayName("Circular")
            
            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    date: Date(),
                    //configuration: ConfigurationIntent(),
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    doneCount: 3,
                    totalCount: 15,
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
            .previewDisplayName("Inline")
            
            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    date: Date(),
                    //configuration: ConfigurationIntent(),
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    doneCount: 3,
                    totalCount: 15,
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .previewDisplayName("Rectangular")
            
            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    date: Date(),
                    //configuration: ConfigurationIntent(),
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    doneCount: 3,
                    totalCount: 15,
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small")

            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    date: Date(),
                    //configuration: ConfigurationIntent(),
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    doneCount: 3,
                    totalCount: 15,
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Medium")

            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    date: Date(),
                    //configuration: ConfigurationIntent(),
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    doneCount: 3,
                    totalCount: 15,
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .previewDisplayName("Large")

            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    date: Date(),
                    //configuration: ConfigurationIntent(),
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    doneCount: 3,
                    totalCount: 15,
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
            .previewDisplayName("ExtraLarge")
        }
    }
}
