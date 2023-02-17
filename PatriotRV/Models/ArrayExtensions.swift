//
//  ArrayExtensions.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/12/23.
//

import Foundation

extension Array where Element == ChecklistItem {

    func done() -> [ChecklistItem] {
        return self.filter { $0.isDone == true }
    }

    func todo() -> [ChecklistItem] {
        return self.filter { $0.isDone == false }
    }

    func category(_ category: TripMode) -> [ChecklistItem] {
        return self.filter { $0.category == category }
    }
}
