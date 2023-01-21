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
        guard let item = model.getItem("fuel") else {
            XCTFail("item before not found")
            return
        }
        XCTAssertFalse(item.isDone)
        
        model.mqtt.messageHandler?("patriot/state/all/x/fuel","55")
        
        guard let item2 = model.getItem("fuel") else {
            XCTFail("item after not found")
            return
        }
        XCTAssertTrue(item2.isDone)
    }
    
    func test_numSelectedItems() throws /* async */ {
        let count = model.numSelectedItems(category: "Departure")
        XCTAssertEqual(count, 23)
    }

    func test_checklist_for_pretrip() throws {
        let count = model.numSelectedItems(category: "Pre-Trip")
        XCTAssertEqual(count, 10)
    }

    func test_checklist_for_arrival() throws {
        let count = model.numSelectedItems(category: "Arrival")
        XCTAssertEqual(count, 17)
    }
    
    func test_setItem_and_numSelectedDone_1() {
        model.setItem(checklistitem: "checkTires", value: "100")
        let count = model.numSelectedDone(category: "Pre-Trip")
        XCTAssertEqual(count, 1)
    }

    func test_setItem_and_numSelectedDone_2() {
        model.setItem(checklistitem: "iceMachine", value: "100")
        model.setItem(checklistitem: "rampAwningIn", value: "100")
        let count = model.numSelectedDone(category: "Departure")
        XCTAssertEqual(count, 2)
    }

    func test_setItem_and_numSelectedDone_1_not3() {
        model.setItem(checklistitem: "checkRoof", value: "100")
        model.setItem(checklistitem: "rearCamera", value: "100")
        model.setItem(checklistitem: "disconnectCables", value: "100")
        let count = model.numSelectedDone(category: "Arrival")
        XCTAssertEqual(count, 1)
    }
    
    func test_uncheckAll_2() {
        model.setItem(checklistitem: "iceMachine", value: "100")
        model.setItem(checklistitem: "rampAwningIn", value: "100")
        model.uncheckAll()
        let count = model.numSelectedDone(category: "Departure")
        XCTAssertEqual(count, 0)
    }

    func test_uncheckAll_3() {
        model.setItem(checklistitem: "checkRoof", value: "100")
        model.setItem(checklistitem: "rearCamera", value: "100")
        model.setItem(checklistitem: "disconnectCables", value: "100")
        model.uncheckAll()
        let count = model.numSelectedDone(category: "Arrival")
        XCTAssertEqual(count, 0)
    }
    


//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
