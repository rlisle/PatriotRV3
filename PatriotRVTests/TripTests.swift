//
//  TripTests.swift
//  PatriotRVTests
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

    func test_nextTrip() throws {
        let date = Date("01/30/23")
        let expectedDate = Date("02/03/23")
        let trip = model.nextTrip(date: date)
        XCTAssertNotNil(trip)
        XCTAssertEqual(trip!.date, expectedDate )
    }

}
