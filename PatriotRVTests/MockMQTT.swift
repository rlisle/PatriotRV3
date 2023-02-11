//
//  MockMQTT.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/11/23.
//

import Foundation

final class MockMQTT: Publishing {
    
    var isConnected = true
    var messageHandler: ((String, String) -> Void)?
    
    var publishedTopic = ""
    var publishedMessage = ""
    
    func publish(topic: String, message: String) {
        publishedTopic = topic
        publishedMessage = message
    }
}
