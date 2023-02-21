//
//  PatriotRvWidget.swift
//  PatriotRvWidget
//
//  Created by Ron Lisle on 1/25/23.
//

import WidgetKit
import SwiftUI
import Intents

//TODO: move to shared file
extension UserDefaults {
    static let group = UserDefaults(suiteName: "group.net.lisles.rvchecklist")!
    enum Keys: String {
        case nextTrip = "NextTrip"
        case tripMode = "TripMode"
        case doneCount = "DoneCount"
        case totalCount = "TotalCount"
        case nextItem = "NextItem"
    }
}

struct Provider: TimelineProvider {
    
    typealias Entry = ChecklistEntry
    
    func placeholder(in context: Context) -> ChecklistEntry {
        ChecklistEntry(
           nextTrip: "Who knows?",
           tripMode: "Parked",
           doneCount: 0,
           totalCount: 13,
           nextItem: "Choose destination")
    }

    func loadString(_ key: UserDefaults.Keys) -> String {
        return UserDefaults.group.string(forKey: key.rawValue) ?? "Not found"
    }
    
    func loadInt(_ key: UserDefaults.Keys) -> Int {
        return UserDefaults.group.integer(forKey: key.rawValue)
    }

    func getSnapshot(in context: Context, completion: @escaping (ChecklistEntry) -> ()) {
        
        let nextTrip = loadString(.nextTrip)
        let tripMode = loadString(.tripMode)
        let doneCount = loadInt(.doneCount)
        let totalCount = loadInt(.totalCount)
        let nextItem = loadString(.nextItem)

        let entry = ChecklistEntry(
               nextTrip: nextTrip,
               tripMode: tripMode,
               doneCount: doneCount,
               totalCount: totalCount,
               nextItem: nextItem)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries = [
            ChecklistEntry(
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
    let date = Date()
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
        StaticConfiguration(kind: kind,
                            provider: Provider()) { entry in
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
        }
    }
}
