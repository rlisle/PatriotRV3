//
//  ChecklistWidgetLiveActivity.swift
//  PatriotRV
//
//  LiveActivities are only available on iPhone
//  Supports Dynamic Island
//  Use ActivityKit to update
//
//  Created by Ron Lisle on 2/25/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ChecklistWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
                
        ActivityConfiguration(for: PatriotRvWidgetAttributes.self) { context in
            
            LockScreenChecklistLiveActivityView(context: context)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack {
                        Text("\(context.state.nextTripName)")

                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing) {
                        Text("\(context.state.tripMode.rawValue)")
                        Text("\(context.state.numberDone) of \(context.state.numberItems)")
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Gauge(value: Float(context.state.numberDone), in: 0...Float(context.state.numberItems)) {
                            Text("")
                        } currentValueLabel: {
                            Text(context.state.nextItemName).font(.title)
                        } minimumValueLabel: {
                            Text(String(context.state.numberDone)).font(.caption)
                        } maximumValueLabel: {
                            Text(String(context.state.numberItems)).font(.caption)
                        }
                        .gaugeStyle(.accessoryLinearCapacity)
                    }
                }
            } compactLeading: {
                Text(context.state.tripMode.rawValue)
            } compactTrailing: {
                Text("\(context.state.numberDone) of \(context.state.numberItems)")
            } minimal: {
                Text("\(context.state.numberDone)/\(context.state.numberItems)")
            }
            .widgetURL(URL(string: "patriot:///list"))
            .keylineTint(Color.red)
        }
    }
    
}

struct LockScreenChecklistLiveActivityView: View {
    let context: ActivityViewContext<PatriotRvWidgetAttributes>
    
    var body: some View {
        VStack {
            HStack {
                Text("\(context.state.nextTripName)")
                Spacer()
                Text("\(context.state.numberDone) of \(context.state.numberItems)")
            }.font(.caption)
            
            Gauge(value: Float(context.state.numberDone), in: 0...Float(context.state.numberItems)) {
                Text("\(context.state.tripMode.rawValue): \(context.state.nextItemName)")
            } currentValueLabel: {
                Text("\(context.state.numberDone)").font(.body)
            } minimumValueLabel: {
                Text("0").font(.caption)
            } maximumValueLabel: {
                Text(String(context.state.numberItems)).font(.caption)
            }
            .gaugeStyle(.accessoryLinearCapacity)
        }
        .padding()
        .activityBackgroundTint(Color.cyan) // Set color based on todos
        .activitySystemActionForegroundColor(Color.black)
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
            .previewDisplayName("Lock Screen")
    }
}
