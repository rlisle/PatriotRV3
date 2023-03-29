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

// Currently disabled

import ActivityKit
import WidgetKit
import SwiftUI

struct PowerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
                
        ActivityConfiguration(for: PatriotRvWidgetAttributes.self) { context in
            LockScreenPowerLiveActivityView(context: context)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack {
                        Text(rvAmps(context.state.rvAmps))
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    HStack {
                        Text("RV")
                        WidgetCircularPowerView(
                            title: "RV Power Usage",
                            amps: context.state.rvAmps,
                            tint: powerTint(context.state.rvAmps))
                        .padding(.trailing,16)
                        Text("Tesla")
                        WidgetCircularPowerView(
                            title: "Tesla Charging",
                            amps: context.state.teslaAmps,
                            tint: chargingTint(context.state.teslaAmps))
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        Text(teslaAmps(context.state.teslaAmps))
                    }
                }
            } compactLeading: {
                Text(rvAmps(context.state.rvAmps))
            } compactTrailing: {
                Text(teslaAmps(context.state.teslaAmps))
            } minimal: {
                Text("\(context.state.rvAmps)/\(context.state.teslaAmps)")
            }
            .widgetURL(URL(string: "patriot:///power"))
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
        case 0...16:
            color = .green
        case 17...28:
            color = .yellow
        default:
            color = .red
        }
        return color
    }
    
    func chargingTint(_ amps: Int) -> Color {
        var color: Color
        switch amps {
        case 0...6:
            color = .red
        case 7...12:
            color = .yellow
        default:
            color = .green
        }
        return color
    }
}

struct LockScreenPowerLiveActivityView: View {
    let context: ActivityViewContext<PatriotRvWidgetAttributes>
    
    var body: some View {
        HStack {
            Text("RV")
            WidgetCircularPowerView(
                title: "RV Power Usage",
                amps: context.state.rvAmps,
                tint: powerTint(context.state.rvAmps))
            Spacer()
            Text("Tesla")
            WidgetCircularPowerView(
                title: "Tesla Charging",
                amps: context.state.teslaAmps,
                tint: chargingTint(context.state.teslaAmps))
        }
        .padding()
        .activityBackgroundTint(Color.cyan) // Set color based on power usage
        .activitySystemActionForegroundColor(Color.black)
    }
    
    // Normal charging is 24a, so RV is up to 16a
    func powerTint(_ amps: Int) -> Color {
        var color: Color
        switch amps {
        case 0...16:
            color = .green
        case 17...28:
            color = .yellow
        default:
            color = .red
        }
        return color
    }
    
    // Optimal charging is >= 24a
    func chargingTint(_ amps: Int) -> Color {
        var color: Color
        switch amps {
        case 0...5:
            color = .red
        case 6...23:
            color = .yellow
        default:
            color = .green
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
        nextItemIndex: 2,
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
