//
//  ChecklistTests.swift
//  PatriotRVTests
//
//  Created by Ron Lisle on 1/21/23.
//

import XCTest
@testable import PatriotRV

@MainActor
final class ChecklistTests: XCTestCase {

    var model: ViewModel!
    var mockMQTT: MQTTManager!
    
    override func setUpWithError() throws {
        mockMQTT = MockMQTT()
        model = ViewModel()
    }

    func test_messageHandler_sets_item() throws {
        guard let item = model.item("fuel") else {
            XCTFail("item 'fuel' not found")
            return
        }
        XCTAssertFalse(item.isDone)
        
        model.mqtt.messageHandler?("patriot/state/all/x/fuel","55")
        
        guard let item2 = model.item("fuel") else {
            XCTFail("item 'fuel' not found")
            return
        }
        XCTAssertTrue(item2.isDone)
    }
    
    func test_numItemInCategoryDeparture() throws /* async */ {
        let count = model.checklist.category(.departure).count
        XCTAssertEqual(count, 23)
    }

    func test_numItemInCategoryPreTrip() throws {
        let count = model.checklist.category(.pretrip).count
        XCTAssertEqual(count, 10)
    }

    func test_numItemInCategoryArrival() throws {
        let count = model.checklist.category(.arrival).count
        XCTAssertEqual(count, 17)
    }
    
    func test_updateDone_and_numDone_1() {
        model.updateDone(key: "checkTires", value: true)
        let count = model.checklist.category(.pretrip).done().count
        XCTAssertEqual(count, 1)
    }

    func test_updateDone_and_numDone_2() {
        model.updateDone(key: "iceMachine", value: true)
        model.updateDone(key: "rampAwningIn", value: true)
        let count = model.checklist.category(.departure).done().count
        XCTAssertEqual(count, 2)
    }

    func test_updateDone_and_numDone_1_not3() {
        model.updateDone(key: "checkRoof", value: true)
        model.updateDone(key: "rearCamera", value: true)
        model.updateDone(key: "disconnectCables", value: true)
        let count = model.checklist.category(.arrival).done().count
        XCTAssertEqual(count, 1)
    }
    
    func test_uncheckAll_2() {
        model.updateDone(key: "iceMachine", value: true)
        model.updateDone(key: "rampAwningIn", value: true)
        let count1 = model.checklist.done().count
        XCTAssertEqual(count1, 2)
        model.uncheckAll()
        let count2 = model.checklist.done().count
        XCTAssertEqual(count2, 0)
    }

    func test_uncheckAll_3() {
        model.updateDone(key: "checkRoof", value: true)
        model.updateDone(key: "rearCamera", value: true)
        model.updateDone(key: "disconnectCables", value: true)
        model.uncheckAll()
        let count = model.checklist.done().count
        XCTAssertEqual(count, 0)
    }

    func test_nextItem_updated() {
        // Initially first item is nextItem
        XCTAssertEqual(model.nextItemIndex, 0)
        // Setting it advances to next item
        model.updateDone(key: "startList")
        XCTAssertEqual(model.nextItemIndex, 1)
        // Setting later item doesn't change it
        model.updateDone(key: "dumpTanks")
        XCTAssertEqual(model.nextItemIndex, 1)
        // But restoring it moves it back
        model.updateDone(key: "startList")
        XCTAssertEqual(model.nextItemIndex, 0)
    }

}
