//
//  WatchChecklistRow.swift
//  PatriotRVWatchApp
//
//  Created by Ron Lisle on 2/12/23.
//
import SwiftUI

struct WatchChecklistRow: View {
    
    @EnvironmentObject var model: WatchModel
    var listItem: ChecklistItem

    var listItemIndex: Int {
        model.checklist.firstIndex(where: { $0.id == listItem.id })!
    }

    var body: some View {

        HStack {
            Text(listItem.name).strikethrough(listItem.isDone)
            Spacer()
            Checkmark(isDone: $model.checklist[listItemIndex].isDone)
        }
    }
}

struct WatchChecklistRow_Previews: PreviewProvider {
    static let model = WatchModel()
    static var previews: some View {
        WatchChecklistRow(listItem: model.checklist[0])
            .environmentObject(model)
            .previewLayout(.fixed(width: 300, height: 40))
            .previewDisplayName("WatchChecklistRow")

    }
}
