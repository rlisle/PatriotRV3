//
//  HomeView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 1/22/23.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var model: ViewModel
    
    @State var tripLink: Bool = false
    @State var checklistLink: Bool = false
    
    @State private var showCompleted = true
    @State private var showSettings = false
    @State private var showLogin = false

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
                    TripSection(selection: $selection)
                    ChecklistSection(selection: $selection)
                    PowerSection()
                    LogSection()
                }
                .listStyle(.grouped)
                .padding(.top, -8)
            }
            .modifier(HomeDestinations(trip: model.trips.last!, item: model.checklist.todo().first!))
            .navigationTitle("Patriot RV")
            .blackNavigation
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
        .sheet(isPresented: $showLogin) {
            LoginView()
        }
        .onOpenURL(perform: { (url) in
            switch url {
            case URL(string: "patriot:///trip"):
                selection.append("trip")
            case URL(string: "patriot:///list"):
                selection.append("list")
            case URL(string: "patriot:///nextitem"):
                selection.append("list")
            case URL(string: "patriot:///power"):
                selection.append("power")
            default:
                print("unknown link url: \(url)")
            }
        })
    } //body
}


struct TripSection: View {
    
    @EnvironmentObject var model: ViewModel
    @Binding var selection: [String]

    var body: some View {
        Section {
            NavigationLink(value: "trip") {
                TripRowView(trip: model.trips.last)
                    .swipeActions(edge: .trailing) {
                        Button {
                            print("TODO: edit")
                            selection.append("edittrip")
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.cyan)
                        Button {
                            selection.append("addtrip")
                            print("TODO: add")
                        } label: {
                            Label("Add", systemImage: "plus")
                        }
                        .tint(.green)
                        Button(role: .destructive) {
                            print("TODO: delete")
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        } header: {
            Text("Next Trip")
        }
    }
}

struct ChecklistSection: View {

//    @EnvironmentObject var model: ViewModel
    @Binding var selection: [String]

    var body: some View {
        Section {
            NavigationLink(value: "itemlist") {
                HomeChecklistRowView()
                    .swipeActions(edge: .trailing) {
                        Button {
                            selection.append("edititem")
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.cyan)
                        Button {
                            selection.append("additem")
                        } label: {
                            Label("Add", systemImage: "plus")
                        }
                        .tint(.green)
                        Button(role: .destructive) {
                            print("TODO: delete")
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        } header: {
            Text("Checklist")
        }
    }
}

struct PowerSection: View {
    var body: some View {
        Section {
            NavigationLink(value: "power") {
                PowerRowView(font: .body)
            }
        } header: {
            Text("Power")
        }
    }
}

struct LogSection: View {
    var body: some View {
        Section {
            NavigationLink(value: "log") {
                LogRowView()
            }
        } header: {
            Text("Log")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ViewModel())
            .modifier(PreviewDevices())
    }
}
