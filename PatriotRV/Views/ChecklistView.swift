//
//  ChecklistView.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/11/21.
//

import SwiftUI

struct ChecklistView: View {

    @EnvironmentObject var modelData: ModelData
    
    @State private var showingAddTrip = false
    
    private var phases: [TripMode] = [.pretrip, .departure,.arrival]
    
    init() {
        UISegmentedControl.appearance().backgroundColor = .black
        UISegmentedControl.appearance().selectedSegmentTintColor = .selectable
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    var body: some View {
        
        NavigationStack {
                    
            VStack {
                
                ImageHeader(imageName: "truck-rv")

                Picker("Phase", selection: $modelData.checklistPhase) {
                    ForEach(phases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 0)
                .padding(.top, -14)
                .background(Color.black)

                ChecklistItemsListView()
            }
            .blackNavigation
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddTrip = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .foregroundColor(.white)
                }
            }
            .navigationDestination(isPresented: $showingAddTrip, destination: {
                AddTripView()
            })
                
        } //NavigationStack
        .accentColor(.black)   // Sets back button color
    }
}

struct ChecklistView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ForEach(["iPhone 11 Pro", "iPad"], id: \.self) { deviceName in
                ChecklistView()
                    .environmentObject(ModelData(mqttManager: MockMQTTManager()))
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName(deviceName)
            }
        }
    }
}
