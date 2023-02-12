//
//  ChecklistView.swift
//  PatriotRVWatchApp
//
//  Created by Ron Lisle on 1/22/23.
//

import SwiftUI

struct WatchChecklistView: View {
    
    @EnvironmentObject var model: WatchModel

    var body: some View {
        List {
            ForEach(model.checklist, id: \.self) { item in
                    WatchChecklistRow(listItem: item)
            }
        }
    }
}

struct WatchChecklistView_Previews: PreviewProvider {
    static var previews: some View {
        WatchChecklistView()
            .environmentObject(WatchModel())
    }
}
