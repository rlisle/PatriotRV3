//
//  Connectivity.swift
//  PatriotRV
//
//  This file is currently not shared between iOS and watchOS
//
//  Created by Ron Lisle on 2/11/23.
//

import Foundation
import Combine
import WatchConnectivity

final class Connectivity: NSObject, ObservableObject {
    
    @Published var lastDoneKey: String? = nil     // nil means none

    static let shared = Connectivity()

    override private init() {

        super.init()
        
        #if !os(watchOS)
        guard WCSession.isSupported() else {
            print("WCSession not supported")
            return
        }
        #endif
        
        WCSession.default.delegate = self
        print("Connectivity activate")
        WCSession.default.activate()
    }
    
    public func send(key: String) {
        guard canSendToPeer() else {
            print("Can't send nextItem to peer")
            return
        }
        
        let userInfo: [String: Any] = [
            ConnectivityUserInfoKey.nextItemKey.rawValue: key
        ]
        WCSession.default.transferUserInfo(userInfo)
    }
    
    public func sendNextTrip(_ trip: Trip) {
        guard canSendToPeer() else {
            print("Can't send nextTrip to peer")
            return
        }
        
        let userInfo: [String: Any] = [
            ConnectivityUserInfoKey.nextTrip.rawValue: trip.destination,
            ConnectivityUserInfoKey.nextTripDate.rawValue: trip.date
        ]
        WCSession.default.transferUserInfo(userInfo)
    }
    
    private func canSendToPeer() -> Bool {
      guard WCSession.default.activationState == .activated else {
          print("canSendToPeer not .activated")
          return false
      }

      #if os(watchOS)
      guard WCSession.default.isCompanionAppInstalled else {
          print("canSendToPeer companion app not installed")
          return false
      }
      #else
          guard WCSession.default.isWatchAppInstalled else {
              print("canSendToPeer watch app not installed")
              return false
          }
      #endif

        print("canSendToPeer true")
        return true
    }

}

extension Connectivity: WCSessionDelegate {
    
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        print("ActivationDidCompleteWith state: \(activationState), error: \(error)")
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // If the person has more than one watch, and they switch,
        // reactivate their session on the new device.
        print("sessionDidDeactivate")
        WCSession.default.activate()
    }
    #endif
    
    func session(_ session: WCSession,
                 didReceiveUserInfo userInfo: [String: Any] = [:]
                ) {
        // Receiving nextItem indicates it is 'Done'
        let keyKey = ConnectivityUserInfoKey.nextItem.rawValue
        guard let key = userInfo[keyKey] as? String else {
            print("key not found")
            return
        }
        print("App setting done ID done from watch")
        self.lastDoneKey = key
    }

}
