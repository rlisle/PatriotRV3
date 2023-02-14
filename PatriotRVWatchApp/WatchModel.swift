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
    @Published var nextTrip: String = "Canada"
    @Published var nextTripDate: Date? = Date("05/01/23")
    @Published var checklistPhase: TripMode = .pretrip

    override init() {
        super.init()
        
        checklist = Checklist.initialChecklist
        for i in 0..<checklist.count {
            checklist[i].delegate = self
            checklist[i].id = i+1
        }
//        #if !os(watchOS)
//        guard WCSession.isSupported() else {
//            print("WCSession not supported")
//            return
//        }
//        #endif
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    func itemIndex(id: Int) -> Int {        // index s/b id-1
        for index in 0..<checklist.count {
            if checklist[index].id == id {
                return index
            }
        }
        print("itemIndex id not found")
        return 0    // Shouldn't happen
    }

    func setDone(order: Int, value: Bool) {
        let index = itemIndex(id: order)
        checklist[index].isDone = value
        updateApp()
    }
    
    func setDoneIds(doneIds: [Int]) {
        var updatedChecklist = checklist
        for index in 0..<updatedChecklist.count {
            updatedChecklist[index].isDone = doneIds.contains(updatedChecklist[index].id)
        }
        print("Setting updatedChecklist")
        checklist = updatedChecklist
    }
    
    func updateApp() {
        print("Updating app from watch")
        send(doneIds: doneIds())
    }
    
    func uncheckAll() {
        for index in 0..<checklist.count {
            checklist[index].isDone = false
        }
    }

    func doneIds() -> [Int] {
        return checklist.done().map { $0.id }
    }
    
    // Use the other funcs to filter first
    // eg next todo in Departure:
    //   checklist.category("Departure").nextItem()
    func nextItem() -> ChecklistItem? {
        return checklist.todo().first
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
        let key = ConnectivityUserInfoKey.done.rawValue
        guard let ids = userInfo[key] as? [Int] else {
            print("key not found")
            return
        }
        print("Watch setting done IDs from app")
        setDoneIds(doneIds: ids)
    }
}

extension WatchModel: Publishing {
    func publish(id: Int, isDone: Bool) {
        updateApp()
    }
}

