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
        
        //TODO: update widget also
        updateChecklistActivity()
    }
    
    func startChecklistActivity() {
        print("startChecklistActivity")
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            let future = Date(timeIntervalSinceNow: 5)
            guard let trip = trips.first,
                  let nextIndex = nextItemIndex
            else {
                print("Trip and next item info not set")
                print("Not starting checklist activity")
                return
            }
            guard nextIndex < checklist.count else {
                print("nextItemIndex is out of range")
                print("Not starting checklist activity")
                return
            }
            let nextItem = checklist[nextIndex]
            let initialContentState = PatriotRvWidgetAttributes.ContentState(
                rvAmps: Int(rv),
                teslaAmps: Int(tesla),
                battery: 0,
                daysUntilNextTrip: 0,
                nextTripName: trip.destination,
                tripMode: nextItem.tripMode,
                numberItems: checklist.count,
                numberDone: checklist.done().count,
                nextItemIndex: nextIndex,
                nextItemName: nextItem.name
            )
            let activityAttributes = PatriotRvWidgetAttributes(name: "Checklist")
            let activityContent = ActivityContent(state: initialContentState, staleDate: future)
            // Start the live activity
            do {
                checklistActivity = try Activity.request(attributes: activityAttributes, content: activityContent)
//                print("Started power monitor live activity: \(String(describing: powerActivity))")
            } catch (let error) {
                print("Error starting power monitor Live Activity \(error.localizedDescription).")
            }
        } else {
            print("Activities not enabled")
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
            await checklistActivity?.update(activityContent)
        }
    }

}
