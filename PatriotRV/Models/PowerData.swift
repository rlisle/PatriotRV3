//
//  PowerData.swift
//  PatriotRV
//
//  Created by Ron Lisle on 1/22/23.
//

import SwiftUI

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
    }
}
