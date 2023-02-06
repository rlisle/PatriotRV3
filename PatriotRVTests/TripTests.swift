//
//  TripTests.swift
//  TripTests
//
//  Created by Ron Lisle on 2/3/23.
//

import XCTest
@testable import PatriotRV

final class TripTests: XCTestCase {

    var model: ModelData!
    var mockMQTT: MQTTManagerProtocol!
    
    override func setUpWithError() throws {
        mockMQTT = MockMQTT()
        model = ModelData(mqttManager: mockMQTT)
    }

    func test_nextTrip_nil() throws {
        let date = Date("01/01/21")
        let trip = model.nextTrip(date: date)
        XCTAssertNil(trip)
    }
    
    func test_nextTrip_2022() throws {
        let date = Date("07/14/22")
        let expectedDate = Date("07/26/22")
        let trip = model.nextTrip(date: date)
        if let trip = trip {
            XCTAssertEqual(trip.date, expectedDate )
        } else {
            XCTFail("nextTrip should not be nil")
        }
    }
    
    func test_nextTrip_2023() throws {
        let date = Date("01/30/23")
        let expectedDate = Date("02/03/23")
        let trip = model.nextTrip(date: date)
        if let trip = trip {
            XCTAssertEqual(trip.date, expectedDate )
        } else {
            XCTFail("nextTrip should not be nil")
        }
    }

    func test_nextTrip_same_day() throws {
        let date = Date("02/03/23")
        let expectedDate = Date("02/03/23")
        let trip = model.nextTrip(date: date)
        if let trip = trip {
            XCTAssertEqual(trip.date, expectedDate )
        } else {
            XCTFail("nextTrip should not be nil")
        }
    }

}
