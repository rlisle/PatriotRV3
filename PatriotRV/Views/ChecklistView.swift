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
    @State private var phase = "Pre-Trip"
    private var phases = ["Pre-Trip", "Departure", "Arrival", "Maintenance"]

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
                            Text(phase)
                            Spacer()
                        Text("(\(modelData.numSelectedDone(category: phase)) of \(modelData.numSelectedItems(category: phase)) done)")
                        }
                        .padding(.vertical, 8)
                    ) {
                        
                        
                        if(modelData.numSelectedItems(category: phase) == 0) {
                            Text("No \(phase) items found")
                        } else {
                            ForEach(modelData.checklist(category: phase).filter { isShown(item:$0) }, id: \.self) { item in
                                
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
