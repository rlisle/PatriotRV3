//
//  Publishing.swift
//  PatriotRV
//
//  Created by Ron Lisle on 2/11/23.
//

import Foundation

protocol Publishing: AnyObject {
    var isConnected: Bool { get }
    var messageHandler: ((String, String) -> Void)? { get set }
    func publish(topic: String, message: String)
}
