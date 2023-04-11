//
//  ChecklistItemsListView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/18/23.
//

import SwiftUI

struct ChecklistItemsListView: View {
    
    @EnvironmentObject var model: ViewModel

    var body: some View {
        List {

            Section(header:
                HStack {
                Text(model.displayPhase.rawValue)
                    Spacer()
                Text("(\(model.checklist.category(model.displayPhase).done().count) of \(model.checklist.category(model.displayPhase).count) done)")
                }
                .padding(.vertical, 8)
            ) {


                if(model.checklist.category(model.displayPhase).todo().count == 0) {
                    Text("No \(model.displayPhase.rawValue) items found")
                } else {
                    ForEach(model.checklist.category(model.displayPhase).todo(), id: \.self) { item in

                      NavigationLink(destination: DetailView(listItem: item)) {
                          ChecklistRowView(listItem: item)
                      }
                    }
                }
            }
            //.textCase(nil)


        } // List
        .padding(.top, -8)
        .listStyle(PlainListStyle())    // Changed from GroupedListStyle
        //.animation(.easeInOut)

    }
}

struct ChecklistItemsListView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChecklistItemsListView()
            .modifier(PreviewDevices())
    }
}
