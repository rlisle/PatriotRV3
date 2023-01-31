//
//  PatriotRvWidgetLiveActivity.swift
//  PatriotRvWidget
//
//  LiveActivities are only available on iPhone
//  Supports Dynamic Island
//  Use ActivityKit to update
//
//  Created by Ron Lisle on 1/25/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PatriotRvWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
                
        ActivityConfiguration(for: PatriotRvWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            LockScreenLiveActivityView(context: context)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    VStack {
                        Text(context.state.tripMode.rawValue)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        Text("ToDo: \(context.state.numberItems - context.state.numberDone)")
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.nextItemName)
                }
            } compactLeading: {
                Text(context.state.tripMode.rawValue)
            } compactTrailing: {
                Text("ToDo: \(context.state.numberItems - context.state.numberDone)")
            } minimal: {
                Text("\(context.state.tripMode.rawValue): \(context.state.numberItems - context.state.numberDone)")
            }
            //.widgetURL(URL(string: "http://www.lisles.net"))
            //.keylineTint(Color.red)
        }
    }
}

struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<PatriotRvWidgetAttributes>
    
    var body: some View {
        VStack {
            Text("\(context.state.tripMode.rawValue) Checklist")
            Text("\(context.state.numberItems - context.state.numberDone) of  \(context.state.numberItems) to do")
            Text("Next item: \(context.state.nextItemName)")
        }
        .padding()
        .activityBackgroundTint(Color.cyan) // Set color based on todos
        .activitySystemActionForegroundColor(Color.black)
    }
}

//struct WidgetCircularPowerView: View {
//
//    var title: String
//    var amps: Int
//    var tint: Color
//
//    var body: some View {
//        VStack {
//            Gauge(value: Float(amps), in: 0...50) {
//                Text(title)
//            } currentValueLabel: {
//                Text(amps.formatted())
//            } minimumValueLabel: {
//                Text("0")
//            } maximumValueLabel: {
//                Text("50")
//            }
//            .gaugeStyle(.accessoryCircular)
//            .tint(tint)
//        }
//    }
//}

struct PatriotRvWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = PatriotRvWidgetAttributes(name: "Me")
    static let contentState = PatriotRvWidgetAttributes.ContentState(
        rvAmps: 3,
        teslaAmps: 37,
        tripMode: .pretrip,
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
