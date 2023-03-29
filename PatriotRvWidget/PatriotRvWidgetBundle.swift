//
//  PatriotRvWidgetBundle.swift
//  PatriotRvWidget
//
//  Created by Ron Lisle on 1/25/23.
//

import WidgetKit
import SwiftUI

@main
struct PatriotRvWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        ChecklistWidget()
        NextItemWidget()
        PowerWidget()
        PowerRvWidget()
        PowerWidgetLiveActivity()
        //ChecklistWidgetLiveActivity()
    }
}
