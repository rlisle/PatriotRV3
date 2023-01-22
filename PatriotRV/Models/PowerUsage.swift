//
//  PowerUsage.swift
//  PatriotRV
//
//  Created by Ron Lisle on 1/22/23.
//

import SwiftUI

struct PowerUsage {
    var rv: Float = 2.4
    var tesla: Float = 24.3
    
    var rvTint: Color {
        get {
            if rv + tesla > 50.0 {
                return .red
            } else {
                return rv > 30 ? .yellow : .green
            }
        }
    }
    
    var teslaTint: Color {
        get {
            if rv + tesla > 50.0 {
                return .red
            } else {
                return tesla > 30 ? .yellow : .green
            }
        }
    }
}
