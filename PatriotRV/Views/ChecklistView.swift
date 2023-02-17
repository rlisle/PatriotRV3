//
//  ChecklistView.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/11/21.
//

import SwiftUI

struct ChecklistView: View {

    @EnvironmentObject var modelData: ModelData
    
    @State private var menuSelection: String? = nil
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

                ChecklistItemsView()
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

struct ChecklistItemsView: View {
    
    @EnvironmentObject var model: ModelData

    var body: some View {
        List {

            Section(header:
                HStack {
                Text(model.checklistPhase.rawValue)
                    Spacer()
                Text("(\(model.checklist.category(model.checklistPhase).done().count) of \(model.checklist.category(model.checklistPhase).done().count) done)")
                }
                .padding(.vertical, 8)
            ) {


                if(model.checklist.todo().count == 0) {
                    Text("No \(model.checklistPhase.rawValue) items found")
                } else {
                    ForEach(model.checklist.todo(), id: \.self) { item in

                      NavigationLink(destination: DetailView(listItem: item)) {
                          ChecklistRow(listItem: item)
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

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ForEach(["iPhone 11 Pro", "iPad"], id: \.self) { deviceName in
                ChecklistView()
                    .environmentObject(ModelData(mqttManager: MQTTManager()))
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName(deviceName)
            }
        }
    }
}
