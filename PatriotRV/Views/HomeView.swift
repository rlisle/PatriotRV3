//
//  HomeView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 1/22/23.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var model: ModelData
    
    @State private var showMenu = false
    @State private var menuSelection: String? = nil
    @State private var showCompleted = true
    @State private var showPower = false    //TODO: remove

    var body: some View {
        NavigationStack {
            
//            NavigationLink(
//                destination: SettingsView().environmentObject(modelData),
//                isActive: $showSettings) { EmptyView() }

            GeometryReader { geometry in
                
                ZStack(alignment: .leading) {   // for sidemenu
                    
                    VStack {
                        
                        ZStack(alignment: .topLeading, content: {
                            Image("truck-rv")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        })

                        List {
                            NavigationLink {
                                PowerView()
                            } label: {
                                PowerRowView()
                            }
                            NavigationLink {
                                ChecklistView()
                            } label: {
                                ChecklistRowView()
                            }
                            NavigationLink {
                                LogView()
                            } label: {
                                LogRowView()
                            }
                        }//list
                        .padding(.top, -8)
                    }//vstack

                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: self.showMenu ? geometry.size.width/2 : 0)
                    .disabled(self.showMenu ? true : false)
                    if self.showMenu {
                        // Close side menu (This breaks onMove
                        let drag = DragGesture()
                            .onEnded {
                                if $0.translation.width < -100 {
                                    withAnimation {
                                        self.showMenu = false
                                    }
                                }
                            }

                        MenuView(showMenu: $showMenu,
                                 showCompleted: $showCompleted,
                                 selection: $menuSelection, isShowingPower: $showPower)
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .leading))
                        .gesture(drag)

                    }

                    
                }//zstack
                .navigationTitle("Summary")
                .blackNavigation

                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("RV Checklist")
                            .foregroundColor(.white)
                    }
                     ToolbarItem(placement: .navigationBarLeading) {
                         Button(action: {
                             withAnimation {
                                 self.showMenu.toggle()
                             }
                         }) {
                             Image(systemName: "line.horizontal.3")
                                 .imageScale(.large)
                         }
                         .foregroundColor(.white)
                     }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation {
                                self.showPower.toggle()
                            }
                        }) {
                            Image(systemName: "gauge.low")
                                .imageScale(.large)
                        }
                        .foregroundColor(.white)
                    }
                }

                
            }//geometryreader
        }//navigationstack
    }//body
}

// Row views should provide summary information
struct PowerRowView: View {
    var body: some View {
        VStack {
            Text("Power")
            RvPowerView()
            TeslaPowerView()
        }
    }
}

struct ChecklistRowView: View {
    var body: some View {
        VStack {
            Text("Checklist")
        }
    }
}

struct LogRowView: View {
    var body: some View {
        Text("Log")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ModelData(mqttManager: MQTTManager()))
    }
}
