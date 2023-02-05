//
//  ModelDataTests.swift
//  PatriotRVTests
//
//  Created by Ron Lisle on 2/4/23.
//

import XCTest
@testable import PatriotRV

final class ModelDataTests: XCTestCase {

    var model: ModelData!
    var mockMQTT: MQTTManagerProtocol!
    
    override func setUpWithError() throws {
        mockMQTT = MockMQTT()
        model = ModelData(mqttManager: mockMQTT)
    }
    
    // CATEGORY
    func test_category_parked() {
        let expected = TripMode.parked
        let date = Date("01/01/19")
        let result = model.category(date: date)
        XCTAssertEqual(result, expected)
    }

    //TODO: add other category cases
    
    func test_checklist_nextItem() {
        let expectedId = "iceMachine"
        setAllItemsBefore(order: 2020)
        let result = model.nextItem()
        XCTAssertEqual(result?.id, expectedId)
    }
    
    // Helpers
    
    func setAllItemsBefore(order: Int) {
        model.checklist.indices.forEach {
            model.checklist[$0].isDone = (model.checklist[$0].order < order)
        }
    }
    
    func restoreChecklist() {
        
    }
}
