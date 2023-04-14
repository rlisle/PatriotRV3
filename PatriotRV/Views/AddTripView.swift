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
    @State private var imageName: String = ""
    @State private var website: String = ""
    
    @MainActor @State private var isLoading = false
    @State private var photosPickerItem: PhotosPickerItem?

    init(trip: Trip? = nil) {
        guard let trip = trip else { return }
        self.date = trip.date
        self.destination = trip.destination
        self.notes = trip.notes ?? ""
        self.address = trip.address ?? ""
        self.imageName = trip.imageName ?? ""
        self.website = trip.website ?? ""
    }
    
    var body: some View {
        Form {
            Section {
                ZStack {
                    VStack {
                        HStack(spacing: 10) {
                            Spacer()
                            PhotosPicker(selection: $photosPickerItem) {
                                Text("Select")
                            }
                            .tint(.accentColor)
                            .buttonStyle(.borderedProminent)
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
                TextField("Image name", text: $imageName)
            }
            Section {
                Button("Save") {
                    let newTrip = Trip(date: date,
                                       destination: destination,
                                       notes: notes,
                                       address: address,
                                       imageName: imageName,
                                       website: website)
                    model.addTrip(newTrip)
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView()
            .modifier(PreviewDevices())
    }
}
