//
//  ItemDelete.swift
//  PatriotRV
//
//  Created by Ron Lisle on 4/16/23.
//

import SwiftUI

struct ItemDelete: View {
    
    let item: ChecklistItem?
    
    var body: some View {
        Text("TODO: Delete Item: \(item?.name ?? "None")")
    }
}

struct ItemDelete_Previews: PreviewProvider {
    static var model = ViewModel()
    static var previews: some View {
        if model.checklist.todo().count > 0 {
            ItemDelete(item: model.checklist.todo().first!)
                .environmentObject(model)
        } else {
            Text("Can't preview: no items")
        }
    }
}
