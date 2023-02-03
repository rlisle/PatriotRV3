//
//  PatriotRVTests.swift
//  PatriotRVTests
//
//  Created by Ron Lisle on 1/21/23.
//

import XCTest
@testable import PatriotRV

final class MockMQTT: MQTTManagerProtocol {
    
    var isConnected = true
    var messageHandler: ((String, String) -> Void)?
    
    var publishedTopic = ""
    var publishedMessage = ""
    
    func publish(topic: String, message: String) {
        publishedTopic = topic
        publishedMessage = message
    }
}

final class PatriotRVTests: XCTestCase {

    var model: ModelData!
    var mockMQTT: MQTTManagerProtocol!
    
    override func setUpWithError() throws {
        mockMQTT = MockMQTT()
        model = ModelData(mqttManager: mockMQTT)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func test_messageHandler() {
        guard let item = model.item("fuel") else {
            XCTFail("item before not found")
            return
        }
        XCTAssertFalse(item.isDone)
        
        model.mqtt.messageHandler?("patriot/state/all/x/fuel","55")
        
        guard let item2 = model.item("fuel") else {
            XCTFail("item after not found")
            return
        }
        XCTAssertTrue(item2.isDone)
    }
    
    func test_numItemInCategoryDeparture() throws /* async */ {
        let count = model.checklist.inCategory("Departure").count
        XCTAssertEqual(count, 23)
    }

    func test_numItemInCategoryPreTrip() throws {
        let count = model.checklist.inCategory("Pre-Trip").count
        XCTAssertEqual(count, 10)
    }

    func test_numItemInCategoryArrival() throws {
        let count = model.checklist.inCategory("Arrival").count
        XCTAssertEqual(count, 17)
    }
    
    func test_setItem_and_numDone_1() {
        model.setDone(checklistitem: "checkTires", value: "100")
        let count = model.checklist.numDone(category: "Pre-Trip")
        XCTAssertEqual(count, 1)
    }

    func test_setItem_and_numSelectedDone_2() {
        model.setDone(checklistitem: "iceMachine", value: "100")
        model.setDone(checklistitem: "rampAwningIn", value: "100")
        let count = model.checklist.numDone(category: "Departure")
        XCTAssertEqual(count, 2)
    }

    func test_setItem_and_numSelectedDone_1_not3() {
        model.setDone(checklistitem: "checkRoof", value: "100")
        model.setDone(checklistitem: "rearCamera", value: "100")
        model.setDone(checklistitem: "disconnectCables", value: "100")
        let count = model.checklist.numDone(category: "Arrival")
        XCTAssertEqual(count, 1)
    }
    
    func test_uncheckAll_2() {
        model.setDone(checklistitem: "iceMachine", value: "100")
        model.setDone(checklistitem: "rampAwningIn", value: "100")
        model.uncheckAll()
        let count = model.checklist.numDone(category: "Departure")
        XCTAssertEqual(count, 0)
    }

    func test_uncheckAll_3() {
        model.setDone(checklistitem: "checkRoof", value: "100")
        model.setDone(checklistitem: "rearCamera", value: "100")
        model.setDone(checklistitem: "disconnectCables", value: "100")
        model.uncheckAll()
        let count = model.checklist.numDone(category: "Arrival")
        XCTAssertEqual(count, 0)
    }
    


}
