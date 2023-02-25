//
//  PatriotRvWidget.swift
//  PatriotRvWidget
//
//  Created by Ron Lisle on 1/25/23.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    
    typealias Entry = ChecklistEntry
    
    func placeholder(in context: Context) -> ChecklistEntry {
        return populatedChecklistEntry()
    }

    func loadString(_ key: UserDefaults.Keys) -> String {
        return UserDefaults.group.string(forKey: key.rawValue) ?? "Not found"
    }
    
    func loadInt(_ key: UserDefaults.Keys) -> Int {
        return UserDefaults.group.integer(forKey: key.rawValue)
    }

    func populatedChecklistEntry() -> ChecklistEntry {
        //TODO: persist this instead of reloading every time
        var nextTrip = "Loading..."
        var tripMode: String = TripMode.parked.rawValue
        var doneCount = 0
        var totalCount = 0
        var nextItem = "Loading..."

        nextTrip = loadString(.nextTrip)
        tripMode = loadString(.tripMode)
        doneCount = loadInt(.doneCount)
        totalCount = loadInt(.totalCount)
        nextItem = loadString(.nextItem)

        return ChecklistEntry(
           nextTrip: nextTrip,
           tripMode: tripMode,
           doneCount: doneCount,
           totalCount: totalCount,
           nextItem: nextItem)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ChecklistEntry) -> ()) {
        
        print("Widget: getSnapshot")
        
        // Use sample data if context.isPreview == true
        completion(populatedChecklistEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries = [
            populatedChecklistEntry()
        ]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

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

        default:
            ZStack {
                Color("WidgetBackground")
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

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: Provider()) { entry in
            ChecklistWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("RV Checklist")
        .description("RV Trip Checklist")
        .supportedFamilies([.accessoryRectangular, .accessoryInline, .accessoryCircular, .systemLarge, .systemMedium, .systemSmall])
        // What about .accessoryCorner?
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
