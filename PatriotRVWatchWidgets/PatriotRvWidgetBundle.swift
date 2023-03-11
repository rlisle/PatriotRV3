//
//  PatriotRvWatchWidgetBundle.swift
//  PatriotRvWatchWidget
//
//  Created by Ron Lisle on 1/25/23.
//

import WidgetKit
import SwiftUI

@main
struct PatriotRvWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        ChecklistWatchWidget()
//        PowerWatchWidget()
    }
}
