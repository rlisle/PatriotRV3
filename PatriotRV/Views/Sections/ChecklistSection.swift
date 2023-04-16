//
//  ChecklistSection.swift
//  PatriotRV
//
//  Created by Ron Lisle on 4/15/23.
//

import SwiftUI

struct ChecklistSection: View {

//    @EnvironmentObject var model: ViewModel
    @Binding var selection: [String]

    var body: some View {
        Section {
            NavigationLink(value: "itemlist") {
                HomeChecklistRowView()
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            //TODO: .confirmationDialog and action
                            print("TODO: delete")
                            selection.append("deletetrip")
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        } header: {
            Text("Checklist")
        }
    }
}

struct ChecklistSection_Previews: PreviewProvider {
    static var selection = [""]
    static var previews: some View {
        List {
            ChecklistSection(selection: .constant(selection))
                .environmentObject(ViewModel())
        }
        .previewLayout(.fixed(width: 640, height: 60))
    }
}
