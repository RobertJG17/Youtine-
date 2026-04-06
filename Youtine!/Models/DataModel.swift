//
//  Model.swift
//  Youtine!
//
//  Created by Bobby Guerra on 2/19/26.
//

import SwiftData
import SwiftUI

@Model
class Routine: Identifiable {
    var id: UUID
    var position: Double
    var title: String
    var start: Date
    var cadence: Cadence
    @Relationship(deleteRule: .cascade) var habits: [Habit]

    init(
        id: UUID,
        position: Double,
        title: String,
        start: Date,
        cadence: Cadence,
        habits: [Habit]
    ) {
        self.id = id
        self.position = position
        self.title = title
        self.start = start
        self.cadence = cadence
        self.habits = habits
    }
}

@Model
class Habit: Identifiable {
    var id: UUID
    var position: Double = 0.0
    var label: String
    var completed: Bool
    
    init(label: String) {
        self.id = UUID()
        self.label = label
        self.completed = false
    }
}

@Observable
class RoutineDraft: Identifiable {
    var id: UUID
    var position: Double
    var title: String
    var start: Date
    var cadence: Cadence
    var habits: [HabitDraft]

    init() {
        self.id = UUID() // Generate a unique identifier
        self.position = 0.0
        self.title = ""
        self.start = .init()
        self.cadence = .daily
        self.habits = []
    }
}

@Observable
class HabitDraft: Identifiable {
    var id: UUID
    var position: Double
    var label: String
    var completed: Bool
    
    init(label: String) {
        self.id = UUID()
        self.position = 0.0
        self.label = label
        self.completed = false
    }
}

