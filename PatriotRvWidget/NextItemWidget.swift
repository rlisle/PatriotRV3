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
            
        case .accessoryCircular:
            ZStack {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .opacity(0.5)
                VStack {
                    Text("\(entry.nextItem.word(0))")
                    Text("\(entry.nextItem.word(1))")
                    if entry.nextItem.numWords() > 2 {
                        Text("\(entry.nextItem.word(2))")
                    }
                }
            }

        default:
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(entry.tripMode)
                        Spacer()
                        Text("\(entry.doneCount) of \(entry.totalCount)")
                    }.font(.subheadline)
                    Text(entry.nextTrip)
                        .font(.headline)
                    Text("Next: ")
                        .padding(.top, 1)
                        .font(.subheadline)
                    Text(entry.nextItem).font(.headline)
                    Spacer()
                    HStack {
                        Spacer()
                        Link(destination: URL(string: "patriot:///previtem")!, label: {
                            Text("<")
                        })
                        Spacer()
                        Link(destination: URL(string: "patriot:///itemdone")!, label: {
                            Image(systemName: "checkmark.square")
                        })
                        Spacer()
                    }
                    .padding(16)
                }
                .padding(16)
                
                if family == .systemMedium {
                    //TODO: show next item picture instead of truck
                    Image("truck-rv")
                        .resizable()
                }
            }
            .background(Color.black)
            .foregroundColor(.white)
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

extension String {
    func word(_ index: Int) -> String {
        let words = self.byWords
        guard words.count > index else {
            return " "
        }
        return String(words[index])
    }
    
    func numWords() -> Int {
        let words = self.byWords
        return words.count
    }
}

extension StringProtocol where Index == String.Index {
    var byWords: [SubSequence] {
        var byWords: [SubSequence] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { _, range, _, _ in
            byWords.append(self[range])
        }
        return byWords
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
                        nextTrip: "Oakwood Golf Resort",
                        tripMode: "Pre-trip",
                        doneCount: 3,
                        totalCount: 15,
                        nextItem: "Inspect roof"))
                .previewContext(WidgetPreviewContext(family: family))
                .previewDisplayName(String(family.description.dropFirst(numToDrop)))
            }
        }
    }
}
