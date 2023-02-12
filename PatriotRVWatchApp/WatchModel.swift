//
//  WatchModel.swift
//  PatriotRVWatchApp
//
//  Created by Ron Lisle on 2/12/23.
//

import Foundation
import WatchConnectivity

class WatchModel: NSObject, ObservableObject {
    
    @Published var checklist: [ChecklistItem] = []

    override init() {
        super.init()
        
        checklist = Checklist.initialChecklist
        for i in 0..<checklist.count {
            checklist[i].delegate = self
        }
        #if !os(watchOS)
        guard WCSession.isSupported() else {
            return
        }
        #endif
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    func itemIndex(order: Int) -> Int {
        for index in 0..<checklist.count {
            if checklist[index].order == order {
                return index
            }
        }
        print("itemIndex order not found")
        return 0    // Shouldn't happen
    }

    func setDone(order: Int, value: Bool) {
        let index = itemIndex(order: order)
        checklist[index].isDone = value
        updateApp()
    }
    
    func setDoneIds(doneIds: [Int]) {
        var updatedChecklist = checklist
        for index in 0..<updatedChecklist.count {
            updatedChecklist[index].isDone = doneIds.contains(updatedChecklist[index].order)
        }
        checklist = updatedChecklist
    }
    
    func updateApp() {
        print("Updating app from watch")
        Connectivity.shared.send(doneIds: doneOrders())
    }
    
    func uncheckAll() {
        for index in 0..<checklist.count {
            checklist[index].isDone = false
        }
    }

    func doneOrders() -> [Int] {
        return checklist.done().map { $0.order }
    }
}

// WatchConnectivity
extension WatchModel {
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

extension WatchModel: WCSessionDelegate {
    
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
        print("Setting done IDs")
        setDoneIds(doneIds: ids)
    }
}

extension WatchModel: Publishing {
    func publish(id: Int, isDone: Bool) {
        updateApp()
    }
}

