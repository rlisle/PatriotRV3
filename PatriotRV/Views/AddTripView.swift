//
//  AddTripView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 1/28/23.
//

import SwiftUI

struct AddTripView: View {
    
    @EnvironmentObject var model: ViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var date: Date = Date()
    @State private var destination: String = ""
    @State private var notes: String = ""
    @State private var address: String = ""
    @State private var imageName: String = ""
    @State private var website: String = ""

    var body: some View {
        Form {
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
