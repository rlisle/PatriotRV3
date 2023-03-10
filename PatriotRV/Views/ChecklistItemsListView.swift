//
//  ChecklistItemsListView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/18/23.
//

import SwiftUI

struct ChecklistItemsListView: View {
    
    @EnvironmentObject var model: ModelData

    var body: some View {
        List {

            Section(header:
                HStack {
                Text(model.checklistPhase.rawValue)
                    Spacer()
                Text("(\(model.checklist.category(model.checklistPhase).done().count) of \(model.checklist.category(model.checklistPhase).count) done)")
                }
                .padding(.vertical, 8)
            ) {


                if(model.checklist.category(model.checklistPhase).todo().count == 0) {
                    Text("No \(model.checklistPhase.rawValue) items found")
                } else {
                    ForEach(model.checklist.category(model.checklistPhase).todo(), id: \.self) { item in

                      NavigationLink(destination: DetailView(listItem: item)) {
                          ChecklistRowView(listItem: item)
                      }
                    }
                }
            }
            .textCase(nil)


        } // List
        .padding(.top, -8)
        .listStyle(PlainListStyle())    // Changed from GroupedListStyle
        //.animation(.easeInOut)

    }
}

struct ChecklistItemsListView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ForEach(["iPhone 11 Pro", "iPad"], id: \.self) { deviceName in
                ChecklistItemsListView()
                    .environmentObject(ModelData())
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName(deviceName)
            }
        }
    }
}
