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
        ChecklistEntry(date: Date(), configuration: ConfigurationIntent(), nextTrip: "Canada", nextItem: "Plan Trip")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (ChecklistEntry) -> ()) {
        let entry = ChecklistEntry(date: Date(), configuration: configuration, nextTrip: "Canada", nextItem: "Plan Trip")
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [ChecklistEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = ChecklistEntry(date: entryDate, configuration: configuration, nextTrip: "Rockport", nextItem: "Check Roof")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ChecklistEntry: TimelineEntry {
    var date: Date
    let configuration: ConfigurationIntent
    let nextTrip: String
    let nextItem: String
}

struct ChecklistWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Next Trip: \(entry.nextTrip)")
            Text("Next item: \(entry.nextItem)")
            .padding(.horizontal, 32)
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
        ChecklistWidgetEntryView(entry: ChecklistEntry(date: Date(), configuration: ConfigurationIntent(), nextTrip: "Canada", nextItem: "Plan Trip"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
