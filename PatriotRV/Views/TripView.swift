//
//  TripView.swift
//  PatriotRV
//
//  Add, Edit, or Display trip
//
//  Created by Ron Lisle on 1/28/23.
//

import SwiftUI
import PhotosUI

struct TripView: View {
    
    @EnvironmentObject var model: ViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var date: Date = Date()
    @State private var destination: String = ""
    @State private var notes: String = ""
    @State private var address: String = ""
    @State private var website: String = ""
    @State private var photoData: Data? = nil

    @MainActor @State private var isLoading = false
    @State private var photosPickerItem: PhotosPickerItem?

    init(trip: Trip? = nil) {
        guard let trip = trip else { return }
        self.date = trip.date
        self.destination = trip.destination
        self.notes = trip.notes ?? ""
        self.address = trip.address ?? ""
        self.website = trip.website ?? ""
        self.photoData = trip.photoData
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    PhotoView(photoData: photoData, size: .detail)
                    Spacer()
                }
                .overlay(alignment: .topTrailing) {
                    PhotosPicker(selection: $photosPickerItem,
                                 matching: .images) {
                        Image(systemName: "pencil.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 30))
                            .foregroundColor(.accentColor)
                    }
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
                //TODO: display only if something has changed
                Button("Save") {
                    let newTrip = Trip(date: date,
                                       destination: destination,
                                       notes: notes,
                                       address: address,
                                       website: website,
                                       photoData: photoData)
                    model.addTrip(newTrip)
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                    Task {
                        await try? model.saveTrip(newTrip)
                    }
                }
            }
            .onChange(of: photosPickerItem) { selectedPhotosPickerItem in
              guard let selectedPhotosPickerItem else { return }
              Task {
                isLoading = true
                await updatePhotosPickerItem(with: selectedPhotosPickerItem)
                isLoading = false
              }
            }
        }
    }
    
    private func updatePhotosPickerItem(with item: PhotosPickerItem) async {
        photosPickerItem = item
        if let data = try? await item.loadTransferable(type: Data.self) {
            print("Setting photo data")
            photoData = data
        }
    }
    
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView()
            .modifier(PreviewDevices())
    }
}
