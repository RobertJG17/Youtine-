//
//  InlineTip.swift
//  Youtine!
//
//  Created by Bobby Guerra on 3/25/26.
//

import SwiftUI
import TipKit

struct EmptyHabitTip: Tip {
    var title: Text {
        Text("Create a habit")
    }
    var message: Text? {
        Text("Add as many habits as you'd like to track. You can reorganize habits to your liking by dragging and dropping them.")
    }
    var image: Image? {
        Image(systemName: "aqi.medium")
    }
}
