//
//  HomeView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 1/22/23.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var model: ModelData
    
    @State var tripLink: Bool = false
    @State var checklistLink: Bool = false
    
    @State private var showCompleted = true
    @State private var showSettings = false

    enum Screen {
        case settings
        case power
        case checklists
        case trips
    }
    @State private var selection: [String] = []
    
    var body: some View {
        NavigationStack(path: $selection) {
            VStack {
                ImageHeader(imageName: "truck-rv")
                List {
                    Section("Next Trip") {
                        NavigationLink(value: "trip") {
                            TripRowView()
                        }
                    }
                    Section("Checklist") {
                        NavigationLink(value: "list") {
                            HomeChecklistRowView()
                        }
                    }
                    Section("Power") {
                        NavigationLink(value: "power") {
                            PowerRowView(font: .body)
                        }
                    }
                    Section("Log") {
                        NavigationLink(value: "log") {
                            LogRowView()
                        }
                    }
                }
                .listStyle(.grouped)
                .padding(.top, -8)
            }
            .navigationDestination(for: String.self) { dest in
                switch dest {
                case "trip":
                    TripListView()
                case "list":
                    ChecklistView()
                case "power":
                    PowerView()
                default:    // Log
                    LogRowView()
                }
            }
            .navigationTitle("Summary")
            .blackNavigation
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("RV Checklist")
//                        .foregroundColor(.header)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            self.showSettings.toggle()
                        }
                    }) {
                        Image(systemName: "gearshape")
                            .imageScale(.large)
                    }
                    .foregroundColor(.white)
                }
            } //toolbar
            .navigationDestination(isPresented: $showSettings,
                                   destination: {
                SettingsView()
            })
        } //navigationstack
        .task {
            model.startChecklistActivity()
        }
        .onOpenURL(perform: { (url) in
            //url can now be compared for matching url passed from widget eg. patriot://link1
            switch url {
            case URL(string: "patriot:///link1"):
                print("link 1")
                selection.append("trip")
            case URL(string: "patriot:///link2"):
                print("link 2")
                selection.append("list")
            case URL(string: "patriot:///link3"):
                print("link 3")
                selection.append("power")
            case URL(string: "patriot:///power"):
                print("power link")
                selection.append("power")
            default:
                print("unknown link url")
            }
        })
    } //body
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ModelData(mqttManager: MockMQTTManager()))
    }
}
