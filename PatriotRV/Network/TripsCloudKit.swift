//
//  TripsCloudKit.swift
//  PatriotRV
//
//  Created by Ron Lisle on 4/5/23.
//

import CloudKit

//TODO: Convert Trip to CKRecord?

extension ViewModel {
    
    nonisolated func loadTrips() async throws {
        do {
            let records = try await fetchTrips()
            await MainActor.run {
                print("Trips loaded")
                trips = records
            }
            
        } catch {
            print("Error fetching trips")
            throw error
        }
    }

    private nonisolated func fetchTrips() async throws -> [Trip] {
        
        let pred = NSPredicate(value: true)     // All records
        let sort = NSSortDescriptor(key: "date", ascending: false)
        let query = CKQuery(recordType: "Trip", predicate: pred)
        query.sortDescriptors = [sort]
        
        let response = try await CKContainer.default().publicCloudDatabase.records(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 500)
        let records = response.matchResults.compactMap { try? $0.1.get() }
        return records.compactMap(Trip.init)
    }

    func setLoadingTrip() {
        trips = [
            Trip(
            date: Date("01/01/23"),
            destination: "TBD",
            notes: "Loading trips...",
            address: nil,
            imageName: nil,
            website: nil)
        ]
    }

    func saveTrips() async throws {
        //TODO: delete existing trips first?
        
        //TODO: perform this in parallel
        for trip in trips {
            try await saveTrip(trip)
        }
    }
    
    func tripRecordID(_ trip: Trip) -> CKRecord.ID {
        let dateString = formatter.string(from: trip.date)
        let recordName = "\(dateString)-\(trip.destination)"
        return CKRecord.ID(recordName: recordName)
    }
    
    nonisolated func saveTrip(_ trip: Trip) async throws {
        let database = CKContainer.default().publicCloudDatabase
        let record = await CKRecord(recordType: "Trip", recordID: tripRecordID(trip))
        record.setValuesForKeys([
            "date": trip.date,
            "destination": trip.destination,
            "notes": trip.notes ?? "",
            "address": trip.address ?? "?",
            "imageName": trip.imageName ?? "none",
            "website": trip.website ?? "none"
        ])
        do {
            try await database.save(record)
        } catch {
            print("Error saving trip \(record.recordID.recordName): \(error)")
        }
    }
    
    func deleteTrips() async throws {
        //TODO: perform this in parallel
        for trip in trips {
            try await deleteTrip(trip)
        }
        trips = []
    }
    
    private nonisolated func deleteTrip(_ trip: Trip) async throws {
        let database = CKContainer.default().publicCloudDatabase
        let recordName = DateFormatter().string(from: trip.date) + trip.destination
        let recordID = CKRecord.ID(recordName: recordName)
        do {
            print("Deleting record with id: \(recordName)")
            _ = try await database.deleteRecord(withID: recordID)
        } catch {
            print("Error deleting trip \(recordName): \(error)")
        }
    }

}
