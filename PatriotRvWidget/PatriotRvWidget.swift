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
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    let configuration: ConfigurationIntent
    let rv: Int
    let tesla: Int
}

struct PatriotRvWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Power Usage")
            HStack {
                VStack {
                    WidgetRvPowerView()
                    WidgetTeslaPowerView()
                }
            }
            .padding(.horizontal, 32)
        }
        //Text(entry.date, style: .time)
    }
}

struct WidgetRvPowerView: View {

    var model: WidgetPowerModel
    
    var body: some View {
        VStack {
            Gauge(value: model.rv, in: 0...50) {
                Text("RV")
            } currentValueLabel: {
                Text(model.rv.formatted())
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("50")
            }
            .gaugeStyle(.accessoryLinearCapacity)
            .tint(model.rvTint)
        }
    }
}

struct WidgetTeslaPowerView: View {

    var model: WidgetPowerModel
    
    var body: some View {
        VStack {
            Gauge(value: model.tesla, in: 0...50) {
                Text("Tesla")
            } currentValueLabel: {
                Text(model.tesla.formatted())
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("50")
            }
            .gaugeStyle(.accessoryLinearCapacity)
            .tint(model.teslaTint)
        }
    }
}

struct PatriotRvWidget: Widget {
    let kind: String = "PatriotRvWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            PatriotRvWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct PatriotRvWidget_Previews: PreviewProvider {
    static var previews: some View {
        PatriotRvWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
