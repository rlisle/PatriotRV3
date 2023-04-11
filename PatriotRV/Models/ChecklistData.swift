//
//  ChecklistData.swift
//  PatriotRV
//
//  Created by Ron Lisle on 3/26/23.
//

import SwiftUI
import ActivityKit

extension ViewModel {

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
                print("startChecklistActivity nextItemIndex is out of range")
                print("Error: Checklist activity not started")
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
        guard let nextIndex = nextItemIndex,
              let tripMode = nextTripMode(),
              let trip = nextTrip(date: Date()) else {
            print("updateChecklistActivity no next trip or item")
            return
        }
        let daysUntilNextTrip = Calendar.current.dateComponents([.day], from: Date(), to: trip.date).day
        let contentState = PatriotRvWidgetAttributes.ContentState(
            rvAmps: Int(rv),
            teslaAmps: Int(tesla),
            battery: 80,            //TODO: get this from model
            daysUntilNextTrip: daysUntilNextTrip ?? 999,   // "
            nextTripName: trip.destination,
            tripMode: nextTripMode() ?? .parked,
            numberItems: checklist.category(tripMode).count,
            numberDone: checklist.category(tripMode).done().count,
            nextItemIndex: nextIndex,
            nextItemName: checklist[nextIndex].name
        )
        let activityContent = ActivityContent(state: contentState, staleDate: nil)
        Task {
            print("updateChecklistActivity: nextItem \(contentState.nextItemName)")
            await checklistActivity?.update(activityContent)
        }
    }
    
    func nextTripMode() -> TripMode? {
        guard let nextIndex = nextItemIndex else {
            return nil
        }
        return checklist[nextIndex].tripMode
    }

}
