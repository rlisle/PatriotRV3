//
//  PowerData.swift
//  PatriotRV
//
//  Created by Ron Lisle on 1/22/23.
//

import SwiftUI
import ActivityKit

extension ModelData {

    var rvTint: Color {
        get {
            if rv + tesla > 50.0 {
                return .red
            } else {
                return rv > 40 ? .yellow : .green
            }
        }
    }
    
    var teslaTint: Color {
        get {
            if rv + tesla > 50.0 {
                return .red
            } else {
                return tesla > 36 ? .yellow : .green
            }
        }
    }
    
    func updatePower(line: Int, power: Float) {
        guard line == 0 || line == 1 else {
            print("Invalid line #")
            return
        }
        linePower[line] = power
        calculatePower()
    }
    
    func calculatePower() {
        rv = round(((linePower[0] + linePower[1]) / 120.0) * 10) / 10.0
        //TODO:
        tesla = 40 - rv
        
        updatePowerActivity()
    }
    
    func startPowerActivity() {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            print("starting activity")
            let future = Date(timeIntervalSinceNow: 5)
            let initialContentState = PatriotRvWidgetAttributes.ContentState(rvAmps: 0, teslaAmps:0)
            let activityAttributes = PatriotRvWidgetAttributes(name: "Power")
            let activityContent = ActivityContent(state: initialContentState, staleDate: future)
            // Start the live activity
            do {
                powerActivity = try Activity.request(attributes: activityAttributes, content: activityContent)
                print("Started power monitor live activity: \(String(describing: powerActivity))")
            } catch (let error) {
                print("Error starting power monitor Live Activity \(error.localizedDescription).")
            }
        }
    }
    
    func updatePowerActivity() {
        let contentState = PatriotRvWidgetAttributes.ContentState(rvAmps: Int(rv), teslaAmps: Int(tesla))
        let activityContent = ActivityContent(state: contentState, staleDate: nil)
        Task {
            await powerActivity?.update(activityContent)
        }
    }

}
