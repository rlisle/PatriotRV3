//
//  ChecklistRow.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/22/21.
//

import SwiftUI

struct ChecklistRow: View {
    
    @EnvironmentObject var model: ModelData
    
    var listItem: ChecklistItem

    var body: some View {

        HStack {
            Text(listItem.name).strikethrough(listItem.isDone)
            Spacer()
            Checkmark(isDone: $model.checklist[index()].isDone)
        }
    }
    
    func index() -> Int {
        guard listItem.id - 1 > 0 && listItem.id < model.checklist.count else {
            print("Invalid checklistItem index")
            return 0
        }
        return listItem.id - 1
    }
}

struct ChecklistRow_Previews: PreviewProvider {
    static let modelData = ModelData(mqttManager: MQTTManager())
    static var previews: some View {
        ChecklistRow(listItem: modelData.checklist[0])
            .environmentObject(modelData)
            .previewLayout(.fixed(width: 300, height: 40))
            .previewDisplayName("ChecklistRow")

    }
}
