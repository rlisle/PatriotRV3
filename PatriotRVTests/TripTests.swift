//
//  TripTests.swift
//  TripTests
//
//  Created by Ron Lisle on 2/3/23.
//

import XCTest
@testable import PatriotRV

@MainActor
final class TripTests: XCTestCase {

    var model: ViewModel!
    
    override func setUpWithError() throws {
        model = ViewModel()
    }

    func test_next_2022() throws {
        let date = Date("07/14/22")
        let expectedDate = Date("07/26/22")
        let trip = model.trips.next(date: date)
        if let trip = trip {
            XCTAssertEqual(trip.date, expectedDate )
        } else {
            XCTFail("nextTrip should not be nil")
        }
    }
    
    func test_next_2023() throws {
        let date = Date("01/30/23")
        let expectedDate = Date("02/03/23")
        let trip = model.trips.next(date: date)
        if let trip = trip {
            XCTAssertEqual(trip.date, expectedDate )
        } else {
            XCTFail("nextTrip should not be nil")
        }
    }

    func test_next_same_day() throws {
        let date = Date("02/03/23")
        let expectedDate = Date("02/03/23")
        let trip = model.trips.next(date: date)
        if let trip = trip {
            XCTAssertEqual(trip.date, expectedDate )
        } else {
            XCTFail("nextTrip should not be nil")
        }
    }

}
