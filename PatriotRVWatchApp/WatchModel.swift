//
//  WatchModel.swift
//  PatriotRVWatchApp
//
//  Created by Ron Lisle on 2/12/23.
//

import Foundation
import WatchConnectivity

class WatchModel: NSObject, ObservableObject {
    
    @Published var nextTrip: String = "Wildwood RV, Windsor"
    @Published var nextTripDate: Date? = Date("06/24/23")
    @Published var phase: TripMode = .pretrip
    @Published var nextItem: String = "Waiting on app..."
    @Published var nextItemId: Int = 0
    @Published var isDone: Bool = false

    override init() {
        super.init()
        
//        #if !os(watchOS)
//        guard WCSession.isSupported() else {
//            print("WCSession not supported")
//            return
//        }
//        #endif
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    func setDone(order: Int, value: Bool) {
        print("Watch sending done \(nextItemId) to app")
        send(doneId: nextItemId)
    }
}

// WatchConnectivity
extension WatchModel {
    public func send(doneId: Int) {
        guard canSendToPeer() else {
            print("Can't sent to peer")
            return
        }
        
        let userInfo: [String: Int] = [
            ConnectivityUserInfoKey.nextItemId.rawValue: doneId
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

extension WatchModel: WCSessionDelegate {
    
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
    }
    
//    #if os(iOS)
//    func sessionDidBecomeInactive(_ session: WCSession) {
//    }
//    
//    func sessionDidDeactivate(_ session: WCSession) {
//        // If the person has more than one watch, and they switch,
//        // reactivate their session on the new device.
//        WCSession.default.activate()
//    }
//    #endif
    
    func session(_ session: WCSession,
                 didReceiveUserInfo userInfo: [String: Any] = [:]
                ) {
        
        guard let nextItem = userInfo[ConnectivityUserInfoKey.nextItem.rawValue] as? String,
        let nextItemId = userInfo[ConnectivityUserInfoKey.nextItemId.rawValue] as? Int,
              let nextTrip = userInfo[ConnectivityUserInfoKey.nextTrip.rawValue] as? String,
              let nextTripDate = userInfo[ConnectivityUserInfoKey.nextTripDate.rawValue] as? Date,
              let phase = userInfo[ConnectivityUserInfoKey.phase.rawValue] as? TripMode
        else {
            print("key not found")
            return
        }
        print("Watch setting values from app, next ID \(nextItemId)")
        self.nextTrip = nextTrip
        self.nextTripDate = nextTripDate
        self.phase = phase
        self.nextItemId = nextItemId
        self.nextItem = nextItem
    }
}

extension WatchModel: Publishing {
    func publish(id: Int, isDone: Bool) {
        //Nothing to do now
    }
}

