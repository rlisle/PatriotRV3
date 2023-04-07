//
//  CloudKit.swift
//  PatriotRV
//
//  Created by Ron Lisle on 4/2/23.
//

import CloudKit

extension ViewModel {
    
    func checkAccountStatus() async throws -> CKAccountStatus {
        try await CKContainer.default().accountStatus()
    }
    
    func save() async throws {
        try await saveChecklist()
        try await saveTrips()
    }
}



