//
//  MockMQTTManager.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/18/23.
//

import Foundation

class MockMQTTManager: MQTTManagerProtocol {
    
    var messageHandler: ((String, String) -> Void)?

    func connect() {
        // nothing to do
    }
    
    func publish(topic: String, message: String) {
        print("MockMQTTManager: publish(\(topic): \(message)")
    }
}
