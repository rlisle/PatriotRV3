//
//  ChecklistData.swift
//  PatriotRV
//
//  Created by Ron Lisle on 3/26/23.
//

import SwiftUI
import ActivityKit

extension ViewModel {

    func updateChecklist() {
        
        updateChecklistActivity()
    }
    
    func startChecklistActivity() {
        print("startChecklistActivity")
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            let future = Date(timeIntervalSinceNow: 5)
            let initialContentState = PatriotRvWidgetAttributes.ContentState(
                rvAmps: 0,
                teslaAmps:0,
                battery: 90,
                daysUntilNextTrip: 0,
                nextTripName: "None",
                tripMode: .pretrip,
                numberItems: 10,
                numberDone: 0,
                nextItemIndex: 0,
                nextItemName: "Start Checklist"
            )
            let activityAttributes = PatriotRvWidgetAttributes(name: "Power")
            let activityContent = ActivityContent(state: initialContentState, staleDate: future)
            // Start the live activity
            do {
                powerActivity = try Activity.request(attributes: activityAttributes, content: activityContent)
//                print("Started power monitor live activity: \(String(describing: powerActivity))")
            } catch (let error) {
                print("Error starting power monitor Live Activity \(error.localizedDescription).")
            }
        }
    }
    
    func updateChecklistActivity() {
        print("updateChecklistActivity")
        let contentState = PatriotRvWidgetAttributes.ContentState(
            rvAmps: Int(rv),
            teslaAmps: Int(tesla),
            battery: 80,            //TODO: get this from model
            daysUntilNextTrip: 0,   // "
            nextTripName: "?",      // "
            tripMode: .pretrip,     // "
            numberItems: 10,
            numberDone: 0,
            nextItemIndex: 0,
            nextItemName: "Start Checklist"
        )
        let activityContent = ActivityContent(state: contentState, staleDate: nil)
        Task {
//            print("updatePowerActivity: rv: \(rv) tesla: \(tesla)")
            await powerActivity?.update(activityContent)
        }
    }

}
