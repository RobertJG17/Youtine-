//
//  DraftModel.swift
//  Youtine!
//
//  Created by Bobby Guerra on 2/27/26.
//

import SwiftUI

extension Date {
    func roundedToMinute() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return calendar.date(from: components)!
    }
}

struct RoutineDraft: Identifiable, Equatable {
    static func == (lhs: RoutineDraft, rhs: RoutineDraft) -> Bool {
        return lhs.title == rhs.title
        && lhs.start.roundedToMinute() == rhs.start.roundedToMinute()
        && lhs.cadence == rhs.cadence
        && lhs.habits == rhs.habits
    }
    
    var id: UUID
    var orderIndex: Int
    var title: String
    var start: Date
    var cadence: Cadence
    var habits: [HabitDraft]

    init() {
        self.id = UUID() // Generate a unique identifier
        self.orderIndex = 0
        self.title = ""
        self.start = .init()
        self.cadence = .daily
        self.habits = []
    }
    
    init(from routine: Routine) {
        self.id = routine.id
        self.orderIndex = routine.orderIndex
        self.title = routine.title
        self.start = routine.start
        self.cadence = Cadence(rawValue: routine.cadence)! // dangerous
        self.habits = routine.habits
            .sorted { $0.orderIndex < $1.orderIndex }
            .map { HabitDraft(from: $0) }
    }
}

struct HabitDraft: Identifiable, Equatable {
    static func == (_ lhs: HabitDraft, _ rhs: HabitDraft) -> Bool {
        return lhs.label == rhs.label
    }
    
    var id: UUID
    var orderIndex: Int
    var label: String
    
    init(label: String, orderIndex: Int=0) {
        self.id = UUID()
        self.orderIndex = orderIndex
        self.label = label
    }
    
    init(from habit: Habit) {
        self.id = habit.id
        self.orderIndex = habit.orderIndex
        self.label = habit.label
    }
}
