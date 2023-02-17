//
//  PowerWidgetLiveActivity.swift
//  PatriotRvWidget
//
//  LiveActivities are only available on iPhone
//  Supports Dynamic Island
//  Use ActivityKit to update
//
//  Displays power usage and Tesla charging
//
//  Created by Ron Lisle on 1/25/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PowerWidgetLiveActivity: Widget {
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
                        Text(rvAmps(context.state.rvAmps))
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        Text(teslaAmps(context.state.teslaAmps))
                        //TODO: use color to indicate charge/discharge
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    HStack {
                        WidgetCircularPowerView(
                            title: "RV Power Usage",
                            amps: context.state.rvAmps,
                            tint: powerTint(context.state.rvAmps))
                        .padding(.trailing,16)
                        WidgetCircularPowerView(
                            title: "Tesla Charging",
                            amps: context.state.teslaAmps,
                            tint: chargingTint(context.state.teslaAmps))
                    }
                }
            } compactLeading: {
                Text(rvAmps(context.state.rvAmps))
            } compactTrailing: {
                Text(teslaAmps(context.state.teslaAmps))
            } minimal: {
                Text("\(context.state.rvAmps)a")
            }
            //.widgetURL(URL(string: "http://www.lisles.net"))
            //.keylineTint(Color.red)
        }
    }
    
    func rvAmps(_ amps: Int) -> String {
        return "RV: \(amps)a"
    }
    
    func teslaAmps(_ amps: Int) -> String {
        return "Tesla: \(amps)a"
    }
    
    func powerTint(_ amps: Int) -> Color {
        var color: Color
        switch amps {
        case 0...5:
            color = .green
        case 6...25:
            color = .yellow
        default:
            color = .red
        }
        return color
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

struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<PatriotRvWidgetAttributes>
    
    var body: some View {
        HStack {
            WidgetCircularPowerView(
                title: "RV Power Usage",
                amps: context.state.rvAmps,
                tint: powerTint(context.state.rvAmps))
            WidgetCircularPowerView(
                title: "Tesla Charging",
                amps: context.state.teslaAmps,
                tint: chargingTint(context.state.teslaAmps))
        }
        .padding()
        .activityBackgroundTint(Color.cyan) // Set color based on todos
        .activitySystemActionForegroundColor(Color.black)
    }
    
    func powerTint(_ amps: Int) -> Color {
        var color: Color
        switch amps {
        case 0...5:
            color = .green
        case 6...25:
            color = .yellow
        default:
            color = .red
        }
        return color
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

struct PowerWidgetLiveActivity_Previews: PreviewProvider {
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
