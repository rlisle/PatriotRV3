//
//  DateExtensionTests.swift
//  PatriotRVTests
//
//  Created by Ron Lisle on 2/4/23.
//

import XCTest
@testable import PatriotRV

final class DateExtensionTests: XCTestCase {

    func test_date_3_12_22() throws {
        let string = "03/12/2022"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let expected = dateFormatter.date(from: string)
        
        let result = Date("03/12/22")
        XCTAssertEqual(result, expected)
    }
}
