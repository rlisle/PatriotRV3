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
    
}
