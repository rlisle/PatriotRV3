//
//  PowerWatchWidget.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/25/23.
//

import WidgetKit
import SwiftUI
import Intents


struct PowerWatchWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    
    var entry: Provider.Entry

    var body: some View {
        
        switch family {
        case .accessoryCircular:
            CircularPowerView(tripMode: entry.tripMode, doneCount: entry.doneCount, totalCount: entry.totalCount)

        case .accessoryInline:
            Text("\(entry.nextTrip): \(entry.tripMode) \(entry.doneCount) of \(entry.totalCount)")
            
        default:
            ZStack {
                //Color("WidgetBackground")
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

struct PowerWatchWidget: Widget {
    let kind: String = Constants.powerKind
    
    let accessories: [WidgetFamily] = [.accessoryRectangular, .accessoryInline, .accessoryCircular, .accessoryCorner]
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: Provider()) { entry in
            PowerWatchWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("RV Power")
        .description("RV Power")
        .supportedFamilies(accessories)
    }
}

struct PowerWatchWidget_Previews: PreviewProvider {
    
    static let watchFamilies: [WidgetFamily] = [.accessoryRectangular, .accessoryInline, .accessoryCircular, .accessoryCorner]

    static var previews: some View {
        Group {
            ForEach(watchFamilies,
                id: \.self) { family in
                
                PowerWatchWidgetEntryView(
                    entry: PowerWidgetEntry(
                        nextTrip: "Canada",
                        tripMode: "Parked",
                        doneCount: 3,
                        totalCount: 15,
                        nextItem: "Plan Trip"))
                .previewContext(WidgetPreviewContext(family: family))
                .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 5 (44 mm)"))
                .previewDisplayName(String(family.description.dropFirst(9)))
            }
        }
    }
}
