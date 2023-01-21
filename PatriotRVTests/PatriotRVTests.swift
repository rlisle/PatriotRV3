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

    func test_numSelectedItems() throws /* async */ {
        let count = model.numSelectedItems(category: "Departure")
        XCTAssertEqual(count, 23)
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
