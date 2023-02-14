//
//  Connectivity.swift
//  PatriotRV
//
//  This file is currently not shared between iOS and watchOS
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
        guard canSendToPeer() else {
            print("Can't sent to peer")
            return
        }
        
        let userInfo: [String: [Int]] = [
          ConnectivityUserInfoKey.done.rawValue: doneIds
        ]
        WCSession.default.transferUserInfo(userInfo)
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
    
    func session(_ session: WCSession,
                 didReceiveUserInfo userInfo: [String: Any] = [:]
                ) {
        let key = ConnectivityUserInfoKey.done.rawValue
        guard let ids = userInfo[key] as? [Int] else {
            print("key not found")
            return
        }
        print("App setting done IDs from watch")
        self.doneIds = ids
    }

}
