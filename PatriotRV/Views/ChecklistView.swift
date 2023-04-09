//
//  ChecklistView.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/11/21.
//

import SwiftUI

struct ChecklistView: View {
    @EnvironmentObject var modelData: ViewModel
    @State private var showingAddTrip = false
    
    private var phases: [TripMode] = [.pretrip, .departure,.arrival]
    
    init() {
        UISegmentedControl.appearance().backgroundColor = .black
        UISegmentedControl.appearance().selectedSegmentTintColor = .selectable
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    var body: some View {
        
        VStack {
            
            ImageHeader(imageName: "truck-rv")

            Picker("Phase", selection: $modelData.displayPhase) {
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
            AddChecklistView()
        })
                
//        .accentColor(.black)   // Sets back button color - doesn't work now
    }
}

struct ChecklistView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChecklistView()
            .environmentObject(ViewModel())
            .modifier(PreviewDevices())
    }
}
