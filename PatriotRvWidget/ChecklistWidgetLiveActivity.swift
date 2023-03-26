//
//  ChecklistWidgetLiveActivity.swift
//  PatriotRvWidgetExtension
//
//  LiveActivities are only available on iPhone
//  Supports Dynamic Island
//  Use ActivityKit to update
//
//  Displays checklist info
//
//  Created by Ron Lisle on 3/26/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ChecklistWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
                
        ActivityConfiguration(for: PatriotRvWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            LockScreenChecklistLiveActivityView(context: context)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack {
                        Text(String(context.state.numberDone))
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    HStack {
                        WidgetCircularChecklistView(
                            title: "Checklist",
                            numDone: context.state.numberDone,
                            numTotal: context.state.numberItems
                        )
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        Text(String(context.state.numberItems))
                    }
                }
            } compactLeading: {
                Text(String(context.state.numberDone))
            } compactTrailing: {
                Text(String(context.state.numberDone))
            } minimal: {
                Text("\(context.state.numberDone)/\(context.state.numberItems)")
            }
            .widgetURL(URL(string: "patriot:///checklist"))
        }
    }
}

struct LockScreenChecklistLiveActivityView: View {
    let context: ActivityViewContext<PatriotRvWidgetAttributes>
    
    var body: some View {
        HStack {
            WidgetCircularChecklistView(
                title: "RV Checklist",
                numDone: context.state.numberDone,
                numTotal: context.state.numberItems
            )
        }
        .padding()
        .activityBackgroundTint(Color.cyan) // Set color based on todos
        .activitySystemActionForegroundColor(Color.black)
    }
    
    func chargingTint(_ amps: Int) -> Color {
        var color: Color
        switch amps {
        case 0...5:
            color = .white
        case 6...24:
            color = .green
        default:
            color = .cyan
        }
        return color
    }

}

struct WidgetCircularChecklistView: View {

    var title: String
    var numDone: Int
    var numTotal: Int

    var body: some View {
        VStack {
            Gauge(value: Float(numDone), in: 0...Float(numTotal)) {
                Text(title)
            } currentValueLabel: {
                Text(numDone.formatted())
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text(String(numTotal))
            }
            .gaugeStyle(.accessoryCircular)
        }
    }
}

struct ChecklistWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = PatriotRvWidgetAttributes(name: "Me")
    static let contentState = PatriotRvWidgetAttributes.ContentState(
        rvAmps: 3,
        teslaAmps: 37,
        battery: 79,
        daysUntilNextTrip: 5,
        nextTripName: "Rockport",
        tripMode: TripMode.pretrip,
        numberItems: 14,
        numberDone: 3,
        nextItemId: "fuel",
        nextItemName: "Fill-up Fuel Tanks"
    )

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
