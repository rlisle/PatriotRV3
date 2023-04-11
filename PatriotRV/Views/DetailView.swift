//
//  DetailView.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/13/21.
//

import WebKit
import SwiftUI

struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

struct Test: View {
    var body: some View {
        VStack {
            Text("Testing HTML Content")
            Spacer()
            HTMLStringView(htmlContent: "<h1>This is HTML String</h1>")
            Spacer()
        }
    }
}

struct DetailView: View {
    
    @EnvironmentObject var modelData: ViewModel
    var listItem: ChecklistItem
    
    var body: some View {
        
        VStack {
            
            Text("Description")                   // Title (was listItem.name)
                .font(.title2)
                .multilineTextAlignment(.center)
                .lineLimit(3)
            
            Divider()
            
            let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
            
            HTMLStringView(htmlContent: headerString + listItem.description)
        }
        .padding()
        .navigationTitle(listItem.name)
        .blackNavigation
    }
}

struct DetailView_Previews: PreviewProvider {
    static let modelData = ViewModel()
    
    static var previews: some View {
        DetailView(listItem: modelData.checklist[4])
            .environmentObject(modelData)
            .modifier(PreviewDevices())
    }
}

