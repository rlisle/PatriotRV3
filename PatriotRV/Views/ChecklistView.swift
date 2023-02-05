//
//  ChecklistView.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/11/21.
//

import SwiftUI

struct ChecklistView: View {

    @EnvironmentObject var modelData: ModelData
    
    @State private var showCompleted = true
    @State private var menuSelection: String? = nil
    @State private var showingAddTrip = false
    @State private var phase: TripMode = .maintenance
    private var phases = ["Maintenance", "Pre-Trip", "Departure", "Arrival"]

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

                Picker(selection: $phase, label: Text("Phase")) {
                    ForEach(phases, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 0)
                .padding(.top, -12)
                .background(Color.black)

                // Checklist Section
                List {
                    
                    Section(header:
                        HStack {
                        Text(phase.rawValue)
                            Spacer()
                        Text("(\(modelData.checklist.category(phase).done().count) of \(modelData.checklist.category(phase).done().count) done)")
                        }
                        .padding(.vertical, 8)
                    ) {
                        
                        
                        if(modelData.checklist.category(phase).done().count == 0) {
                            Text("No \(phase.rawValue) items found")
                        } else {
                            ForEach(modelData.checklist.category(phase).filter { isShown(item:$0) }, id: \.self) { item in
                                
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

                
            }//VStack
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
                
        }//NavigationStack
        .accentColor( .black)   // Sets back button color
    }
        
    func isShown(item: ChecklistItem) -> Bool {
        return showCompleted == true || item.isDone == false
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
