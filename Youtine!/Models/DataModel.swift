//
//  Model.swift
//  Youtine!
//
//  Created by Bobby Guerra on 2/19/26.
//

import SwiftUI
import SwiftData

enum Cadence: String, CaseIterable {
    case once = "once"
    case daily = "daily"
    case weekly = "weekly"
    case monthly = "monthly"
}

@Model
class Routine: Identifiable {
    var id: UUID
    var orderIndex: Int
    var title: String
    var start: Date
    var cadence: String
    @Relationship(deleteRule: .cascade) var habits: [Habit]

    init(
        orderIndex: Int,
        title: String,
        start: Date,
        cadence: String,
        habits: [Habit]
    ) {
        self.id = UUID()
        self.orderIndex = orderIndex
        self.title = title
        self.start = start
        self.cadence = cadence
        self.habits = habits
    }
    
    init(from draft: RoutineDraft) {
        self.id = draft.id
        self.orderIndex = draft.orderIndex
        self.title = draft.title
        self.start = draft.start
        self.cadence = draft.cadence.rawValue
        self.habits = draft.habits
            .sorted { $0.orderIndex < $1.orderIndex }
            .map { Habit(from: $0) }
    }
}

@Model
class Habit: Identifiable {
    var id: UUID
    var label: String
    var orderIndex: Int
    var completed: Bool
    var lastCompleted: Date?
    
    init(label: String = "", orderIndex: Int=0, completed: Bool=false) {
        self.id = UUID()
        self.label = label
        self.orderIndex = orderIndex
        self.completed = completed
        self.lastCompleted = nil
    }
    
    init(from draft: HabitDraft, completed: Bool=false) {
        self.id = draft.id
        self.label = draft.label
        self.orderIndex = draft.orderIndex
        self.completed = false
        self.lastCompleted = nil
    }
}

