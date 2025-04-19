//
//  YourRoutineWidgetBundle.swift
//  YourRoutineWidget
//
//  Created by 指原奈々 on 2025/04/19.
//

import WidgetKit
import SwiftUI

@main
struct YourRoutineWidgetBundle: WidgetBundle {
    var body: some Widget {
        YourRoutineWidget()
        YourRoutineWidgetControl()
        YourRoutineWidgetLiveActivity()
    }
}
