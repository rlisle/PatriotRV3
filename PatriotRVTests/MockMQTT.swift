//
//  MockMQTT.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/11/23.
//

import Foundation

protocol MQTTManagerProtocol: AnyObject {
    var isConnected: Bool { get }
    var messageHandler: ((String, String) -> Void)? { get set }
    func publish(topic: String, message: String)
}

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
