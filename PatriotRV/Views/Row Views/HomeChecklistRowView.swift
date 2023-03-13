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
                Text(category().rawValue)
                    .font(.caption)
                Text("\(model.checklist.category(category()).done().count)")
                Text("of")
                    .font(.caption)
                Text("\(model.checklist.category(category()).count)")
                Text("done")
                    .font(.caption)

                Spacer()
                Text("Total: \(model.checklist.done().count) of \(model.checklist.count) done")
                    .font(.caption)
            }
            .padding(.vertical, 4)
            HStack {
                Text("#\(model.checklist.todo().first?.id ?? 0):")
                Text(model.checklist.todo().first?.name ?? "")
                Spacer()
                Checkmark(isDone: $model.checklist[index()].isDone)
            }
        }
    }
    
    func category() -> TripMode {
        return model.checklist.todo().first?.tripMode ?? .parked
    }
    
    func index() -> Int {
        guard let index = model.checklist.todo().first?.id else {
            print("Invalid checklistItem index")
            return 0
        }
        return index - 1
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
