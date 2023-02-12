//
//  Connectivity.swift
//  PatriotRV
//
//  This file is shared between iOS and watchOS
//
//  Created by Ron Lisle on 2/11/23.
//

import Foundation
import WatchConnectivity

final class Connectivity: NSObject, ObservableObject {
    
    @Published var doneIds: [Int] = []   // actually order

    static let shared = Connectivity()

    override private init() {

        super.init()
        
        #if !os(watchOS)
        guard WCSession.isSupported() else {
          return
        }
        #endif
        
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    public func send(doneIds: [Int]) {
        guard canSendToPeer() else { return }
        
        
    }
    
    private func canSendToPeer() -> Bool {
      guard WCSession.default.activationState == .activated else {
        return false
      }

      #if os(watchOS)
      guard WCSession.default.isCompanionAppInstalled else {
        return false
      }
      #else
      guard WCSession.default.isWatchAppInstalled else {
        return false
      }
      #endif

      return true
    }

}

extension Connectivity: WCSessionDelegate {
    
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // If the person has more than one watch, and they switch,
        // reactivate their session on the new device.
        WCSession.default.activate()
    }
    #endif
}
