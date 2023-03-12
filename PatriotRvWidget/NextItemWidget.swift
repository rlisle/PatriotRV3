//
//  NextItemWidget.swift
//  PatriotRvWidgetExtension
//
//  Created by Ron Lisle on 3/12/23.
//
import WidgetKit
import SwiftUI
import Intents

struct NextItemWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    
    var entry: Provider.Entry

    var body: some View {
        
        switch family {
        case .accessoryInline:
            Text("Next: \(entry.nextItem)")
            
        default:
            VStack(alignment: .leading) {
                HStack {
                    Link(destination: URL(string: "patriot:///link1")!, label: {
                        Text("Trip: ")
                        Spacer()
                        Text(entry.nextTrip)
                    })
                }
                Spacer()
                HStack {
                    Link(destination: URL(string: "patriot:///link2")!, label: {
                        Text(entry.tripMode)
                        Spacer()
                        Text("\(entry.doneCount) of \(entry.totalCount)")
                    })
                }
                HStack {
                    Link(destination: URL(string: "patriot:///link3")!, label: {
                        Text("Next: ")
                        Spacer()
                        Text(entry.nextItem)
                    })
                }
            }
            .background(Image("truck-rv").opacity(0.2).scaledToFill())
            .foregroundColor(.black)
            .padding(8)
        }
    }
}

struct NextItemWidget: Widget {
    let kind: String = Constants.nextItemKind
    
    static let accessories: [WidgetFamily] = [
        .accessoryInline,
        .accessoryCircular,
        .systemMedium,
        .systemSmall
    ]
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: Provider()) { entry in
            NextItemWidgetEntryView(entry: entry)
                .widgetURL(URL(string: "patriot:///nextitem")!)
        }
        .configurationDisplayName("Next item")
        .description("RV checklist next item")
        .supportedFamilies(NextItemWidget.accessories)
    }
}

struct NextItemWidget_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ForEach(NextItemWidget.accessories,
                id: \.self) { family in
                let accessory = family.description.hasPrefix("accessory")
                let numToDrop = accessory ? 9 : 6

                NextItemWidgetEntryView(
                    entry: ChecklistEntry(
                        nextTrip: "n/a",
                        tripMode: "n/a",
                        doneCount: 3,
                        totalCount: 15,
                        nextItem: "Inspect roof"))
                .previewContext(WidgetPreviewContext(family: family))
                .previewDisplayName(String(family.description.dropFirst(numToDrop)))
            }
        }
    }
}
