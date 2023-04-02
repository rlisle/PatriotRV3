//
//  SettingsView.swift
//  PatriotRV
//
//  Left side menu
//
//  Created by Ron Lisle on 1/23/23.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var modelData: ViewModel
    
    @State var showCompleted = false
    
    private let enableDangerZone = false

    var body: some View {
        VStack(alignment: .leading) {
                        
            Section(header: Text("Actions")) {
                
                MenuRowView(title: "Uncheck All", iconName: "square", action: {
                    modelData.uncheckAll()
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
                
                // This may help debugging etc. Save s/b automatic though
                MenuRowView(title: "Save", iconName: "square.and.arrow.down.on.square", action: {
                    modelData.save()
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                })

                .padding(.bottom, 60)
            }
                   
            //TODO: move show/hide done to checklist view
            Section(header: Text("Settings")) {
                
                MenuRowView(title: showCompleted ? "Hide Done" : "Show Done", iconName: showCompleted ? "eye.slash" : "eye", action: {
                    showCompleted.toggle()
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
                .padding(.bottom, 60)
            }
            
            if enableDangerZone {
                Section(header: Text("Danger Zone")) {
                    
                    MenuRowView(title: "Seed Database", iconName: "square.and.arrow.up.trianglebadge.exclamationmark", action: {
                        modelData.seedDatabase()
                        withAnimation {
                            presentationMode.wrappedValue.dismiss()
                        }
                    })
                    .padding(.bottom, 60)
                }
            }
            
            Spacer()
        }
        .padding(.top, 80)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 32/255, green: 32/255, blue: 32/255))
        .foregroundColor(.gray)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ViewModel(mqttManager: MockMQTTManager()))
    }
}
