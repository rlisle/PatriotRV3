//
//  HomeChecklistRowView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/17/23.
//

import SwiftUI

struct HomeChecklistRowView: View {
    
    @EnvironmentObject var model: ModelData
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(model.checklist.todo().first?.category.rawValue ?? "Parked")
                    .font(.caption)
//                Text("\(model.checklist.category()done().count) of \(model.checklist.count) done")
                Spacer()
                Text("\(model.checklist.done().count) of \(model.checklist.count) done")
            }
            HStack {
                Text("#\(model.checklist.todo().first?.id ?? 0):")
                Text(model.checklist.todo().first?.name ?? "")
            }
        }
    }
}

struct HomeChecklistRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            HomeChecklistRowView()
                .environmentObject(ModelData(mqttManager: MockMQTTManager()))
        }
    }
}
