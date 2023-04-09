//
//  Checkmark.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/21/21.
//

import SwiftUI

struct Checkmark: View {
    
    @EnvironmentObject var model: ViewModel
    
    let item: ChecklistItem
    
    var body: some View {
        Button(action: {
            model.updateDone(key: item.key)
        }) {
            Image(systemName: item.isDone ? "checkmark.square" : "square")
                .contentShape(Rectangle())
                .onTapGesture {
                    model.updateDone(key: item.key)
                }
        }
    }
}

struct Checkmark_Previews: PreviewProvider {
    static var previews: some View {
        let item = ViewModel.initialChecklist[0]
        Checkmark(item: item)
            .previewLayout(.fixed(width: 40, height: 40))
            .previewDisplayName("Checkmark")
            .environmentObject(ViewModel())
    }
}
