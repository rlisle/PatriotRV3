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

// Moved to WidgetAttributes
//struct PatriotRvWidgetAttributes: ActivityAttributes {
//    public struct ContentState: Codable, Hashable {
//        // Dynamic stateful properties about your activity go here!
//        var rvAmps: Int
//        var teslaAmps: Int
//    }
//
//    // Fixed non-changing properties about your activity go here!
//    var name: String
//}
//
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
                        Text("RV")
                        WidgetCircularPowerView(title: "RV", amps: context.state.rvAmps, tint: .green)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        Text("Tesla")
                        WidgetCircularPowerView(title: "Tesla", amps: context.state.teslaAmps, tint: .green)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("Power Usage")
                }
            } compactLeading: {
                Text("RV: \(context.state.rvAmps)a")
                //WidgetCircularPowerView(title: "RV", amps: context.state.rvAmps, tint: .green)
            } compactTrailing: {
                Text("Tesla: \(context.state.rvAmps)a")
            } minimal: {
                Text("\(context.state.rvAmps)/\(context.state.teslaAmps)")
            }
            //.widgetURL(URL(string: "http://www.lisles.net"))
            .keylineTint(Color.red)
        }
    }
}

struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<PatriotRvWidgetAttributes>
    
    var body: some View {
        VStack {
            Text("Power Usage")
            WidgetPowerView(title: "RV", amps: context.state.rvAmps, tint: .green)
            WidgetPowerView(title: "Tesla", amps: context.state.teslaAmps, tint: .green)
        }
        .padding()
        .activityBackgroundTint(Color.cyan)
        .activitySystemActionForegroundColor(Color.black)
    }
}

struct WidgetCircularPowerView: View {

    var title: String
    var amps: Int
    var tint: Color
    
    var body: some View {
        VStack {
            Gauge(value: Float(amps), in: 0...50) {
                Text(title)
            } currentValueLabel: {
                Text(amps.formatted())
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("50")
            }
            .gaugeStyle(.accessoryCircular)
            .tint(tint)
        }
    }
}

struct PatriotRvWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = PatriotRvWidgetAttributes(name: "Me")
    static let contentState = PatriotRvWidgetAttributes.ContentState(rvAmps: 3, teslaAmps: 37)

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
