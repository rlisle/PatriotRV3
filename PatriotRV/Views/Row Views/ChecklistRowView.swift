//
//  ChecklistRowView.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/22/21.
//

import SwiftUI

struct ChecklistRowView: View {
    
    @EnvironmentObject var model: ViewModel
    
    var listItem: ChecklistItem

    var body: some View {

        HStack {
            Text(listItem.name).strikethrough(listItem.isDone)
            Spacer()
            Checkmark(item: listItem)
        }
    }
}

struct ChecklistRowView_Previews: PreviewProvider {
    static var modelData = ViewModel(mqttManager: MockMQTTManager())
    static var previews: some View {
        List {
            ChecklistRowView(listItem: ViewModel.initialChecklist[0])
                .environmentObject(modelData)
        }
    }
}
