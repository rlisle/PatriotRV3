//
//  WatchModel.swift
//  PatriotRVWatchApp
//
//  Created by Ron Lisle on 2/12/23.
//

import Foundation

class WatchModel: ObservableObject {
    
    @Published var checklist: [ChecklistItem] = []

    init() {
        checklist = Checklist.initialChecklist
    }

    func itemIndex(order: Int) -> Int {
        for index in 0..<checklist.count {
            if checklist[index].order == order {
                return index
            }
        }
        print("itemIndex order not found")
        return 0    // Shouldn't happen
    }

    func setDone(order: Int, value: Bool) {
        let index = itemIndex(order: order)
        checklist[index].isDone = value
    }
    
}
