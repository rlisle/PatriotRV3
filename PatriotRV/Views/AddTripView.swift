//
//  AddTripView.swift
//  PatriotRV
//
//  Also edit trip if trip not nil
//
//  Created by Ron Lisle on 1/28/23.
//

import SwiftUI
import PhotosUI

struct AddTripView: View {
    
    @EnvironmentObject var model: ViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var date: Date = Date()
    @State private var destination: String = ""
    @State private var notes: String = ""
    @State private var address: String = ""
    @State private var website: String = ""
    
    @MainActor @State private var isLoading = false
    @State private var photosPickerItem: PhotosPickerItem?

    init(trip: Trip? = nil) {
        guard let trip = trip else { return }
        self.date = trip.date
        self.destination = trip.destination
        self.notes = trip.notes ?? ""
        self.address = trip.address ?? ""
        self.website = trip.website ?? ""
    }
    
    var body: some View {
        Form {
            Section {
                ZStack {
                    VStack {
                        HStack(spacing: 10) {
                            Spacer()
                            PhotosPicker(selection: $photosPickerItem,
                                         matching: .images) {
                                Text("Select")
                            }
                            .tint(.accentColor)
                            .buttonStyle(.borderedProminent)
                            if isLoading {
                                ProgressView()
                                    .tint(.accentColor)
                            }
                        }
                        Spacer()
                    }
                    PhotoView(photoData: model.tripPhotoData, size: .detail)
                }
            }
            Section {
                DatePicker("Date of trip:", selection: $date, in: Date.now..., displayedComponents: .date)
                TextField("Destination", text: $destination)
                TextField("Address", text: $address)
                TextField("Website", text: $website)
            }
            Section {
                TextField("Notes", text: $notes)
            }
            Section {
                Button("Save") {
                    let newTrip = Trip(date: date,
                                       destination: destination,
                                       notes: notes,
                                       address: address,
                                       website: website)
                    model.addTrip(newTrip)
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onChange(of: photosPickerItem) { selectedPhotosPickerItem in
              guard let selectedPhotosPickerItem else {
                return
              }
              Task {
                isLoading = true
                await updatePhotosPickerItem(with: selectedPhotosPickerItem)
                isLoading = false
              }
            }
        }
    }
    
    private func updatePhotosPickerItem(with item: PhotosPickerItem) async {
        //TODO: redirect to next trip
        photosPickerItem = item
        if let photoData = try? await item.loadTransferable(type: Data.self) {
            model.tripPhotoData = photoData
        }
    }
    
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView()
            .modifier(PreviewDevices())
    }
}
