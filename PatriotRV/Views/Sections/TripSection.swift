//
//  TripSection.swift
//  PatriotRV
//
//  Created by Ron Lisle on 4/15/23.
//

import SwiftUI

struct TripSection: View {
    
    @EnvironmentObject var model: ViewModel
    @Binding var selection: [String]

    var body: some View {
        Section {
            NavigationLink(value: "trip") {
                TripRowView(trip: model.trips.last)
                    .swipeActions(edge: .trailing) {
                        Button {
                            print("TODO: edit")
                            selection.append("edittrip")
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.cyan)
                        Button {
                            selection.append("addtrip")
                            print("TODO: add")
                        } label: {
                            Label("Add", systemImage: "plus")
                        }
                        .tint(.green)
                        Button(role: .destructive) {
                            print("TODO: delete")
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        } header: {
            Text("Next Trip")
        }
    }
}

struct TripSection_Previews: PreviewProvider {
    static var selection = [""]
    static var previews: some View {
        List {
            TripSection(selection: .constant(selection))
                .environmentObject(ViewModel())
        }
        .previewLayout(.fixed(width: 640, height: 60))
    }
}
