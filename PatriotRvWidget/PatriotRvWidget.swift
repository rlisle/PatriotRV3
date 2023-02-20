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
                       nextItem: "Choose destination")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (ChecklistEntry) -> ()) {
        
        let nextTrip = UserDefaults(suiteName: "group.net.lisles.patriotrv")!.string(forKey: "NextTrip")
        let tripMode = UserDefaults(suiteName: "group.net.lisles.patriotrv")!.string(forKey: "TripMode")
        let nextItem = UserDefaults(suiteName: "group.net.lisles.patriotrv")!.string(forKey: "NextItem")

        let entry = ChecklistEntry(date: Date(),
//                                   configuration: configuration,
                                   nextTrip: nextTrip ?? "No trip",
                                   tripMode: tripMode ?? "Parked",
                                   nextItem: nextItem ?? "None")
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries = [
            ChecklistEntry(date: Date(),
                           nextTrip: "Rockport",
                           tripMode: "Parked",
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
    let nextItem: String
}

struct ChecklistWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text("Trip: \(entry.nextTrip)")
            Text(entry.tripMode)
            Text("Next: \(entry.nextItem)")
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
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .previewDisplayName("Circular")
            
            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    date: Date(),
                    //configuration: ConfigurationIntent(),
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
            .previewDisplayName("Inline")
            
            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    date: Date(),
                    //configuration: ConfigurationIntent(),
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .previewDisplayName("Rectangular")
            
            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    date: Date(),
                    //configuration: ConfigurationIntent(),
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small")

            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    date: Date(),
                    //configuration: ConfigurationIntent(),
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Medium")

            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    date: Date(),
                    //configuration: ConfigurationIntent(),
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .previewDisplayName("Large")

            ChecklistWidgetEntryView(
                entry: ChecklistEntry(
                    date: Date(),
                    //configuration: ConfigurationIntent(),
                    nextTrip: "Canada",
                    tripMode: "Parked",
                    nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
            .previewDisplayName("ExtraLarge")
        }
    }
}
