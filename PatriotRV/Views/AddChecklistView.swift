//
//  AddChecklistView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 4/9/23.
//

import SwiftUI
import PhotosUI

struct AddChecklistView: View {
    
    @EnvironmentObject var model: ViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var key: String = ""
    @State private var name: String = ""
    @State private var tripMode: String = "Pre-Trip"
    @State private var description: String = ""
    @State private var sortOrder: String = ""
    @State private var photoData: Data? = nil
//    @State private var isDone: Bool = false
//    @State private var date: Date = Date()

    @MainActor @State private var isLoading = false
    @State private var photosPickerItem: PhotosPickerItem?

    init(item: ChecklistItem? = nil) {
        guard let item = item else { return }
        //self.date = item.date
        self.key = item.key
        self.name = item.name
        self.tripMode = item.tripMode.rawValue
        self.description = item.description
        self.photoData = item.photoData
    }

    var body: some View {
        Form {
            Section {
                Picker("Trip mode:", selection: $tripMode) {
                    ForEach(TripMode.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                TextField("Key", text: $key)
                TextField("Name", text: $name)
                TextField("Description", text: $description)
            }
            Section {
                TextField("Sort order", text: $sortOrder)
            }
//            Section {
//                EditableImage()
//            }
            Section {
                Button("Save") {
                    if let order = Int(sortOrder) {
                        let newItem = ChecklistItem(key: key,
                                                    name: name,
                                                    category: TripMode(rawValue: tripMode)!,
                                                    description: description,
                                                    sortOrder: order,
                                                    photoData: photoData,
                                                    isDone: false)
                        model.addChecklistItem(newItem)
                        withAnimation {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}

struct AddChecklistView_Previews: PreviewProvider {
    static var previews: some View {
        AddChecklistView()
            .modifier(PreviewDevices())
    }
}
