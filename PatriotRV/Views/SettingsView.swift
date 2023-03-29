//
//  SettingsView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 1/23/23.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var modelData: ViewModel
    
    @State var showCompleted = false

    var body: some View {
        VStack(alignment: .leading) {
                        
            Section(header: Text("Actions")) {
                
                MenuRowView(title: "Uncheck All", iconName: "square", action: {
                    modelData.uncheckAll()
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
                .padding(.bottom, 60)
            }
                        
            Section(header: Text("Settings")) {
                
                MenuRowView(title: showCompleted ? "Hide Done" : "Show Done", iconName: showCompleted ? "eye.slash" : "eye", action: {
                    showCompleted.toggle()
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
                .padding(.bottom, 60)
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
