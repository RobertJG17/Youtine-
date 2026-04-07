//
//  ViewModel.swift
//  Youtine!
//
//  Created by Bobby Guerra on 2/28/26.
//

import SwiftUI
import Observation
import SwiftData

@Observable
class RoutineViewModel {
    let formState: FormState
    private var modelContext: ModelContext?
    var persistedRoutine: Routine?
    var draft: RoutineDraft
    var original: RoutineDraft
    
    // move hasChanges to here instead of passing view model thru to ViewModifier
    var hasChanges: Bool {
        self.draft != self.original
    }
    
    init(routine: Routine?, index: Int) {        
        if let routine {
            self.formState = .editing
            self.persistedRoutine = routine
            self.draft = RoutineDraft.init(from: routine)
            self.original = RoutineDraft.init(from: routine)
        } else {
            self.formState = .creating
            self.draft = RoutineDraft.init()
            self.original = RoutineDraft.init()
            
            self.draft.orderIndex = index
            self.original.orderIndex = index
        }
        
    }
    
    func configure(with context: ModelContext) {
        self.modelContext = context
    }

    func addHabit(label: String) {
        withAnimation {
            let habit = HabitDraft(label: label, orderIndex: draft.habits.count)
            draft.habits.append(habit)
        }
    }
    
    func deleteHabit(id: UUID) {
        withAnimation {
            draft.habits.removeAll(where: { $0.id == id })
        }
    }
    
    func moveHabit(from source: IndexSet, to destination: Int) {
        withAnimation {
            draft.habits.move(fromOffsets: source, toOffset: destination)
            for i in 0 ..< draft.habits.count {
                draft.habits[i].orderIndex = i
            }
        }
    }
    
    func saveRoutine() throws {
        switch formState {
            case .creating:
                let routine = Routine(from: draft)
                modelContext?.insert(routine)
                NotificationsService.shared.addNotification(routine: routine)
            case .editing:
                guard let routine = persistedRoutine else { return }
                self.update(routine)
                NotificationsService.shared.updateNotification(routine: routine)
        }

        self.commit()
    }
    
    func update(_ routine: Routine) {
        routine.title = draft.title
        routine.start = draft.start
        routine.cadence = draft.cadence.rawValue

        let draftIDs = Set(draft.habits.map { $0.id })
        
        for habit in routine.habits where !draftIDs.contains(habit.id) {
            modelContext?.delete(habit)
        }
        
        for (_, draftHabit) in draft.habits.enumerated() {
            if let existing = routine.habits.first(where: { $0.id == draftHabit.id }) {
                existing.label = draftHabit.label
                existing.orderIndex = draftHabit.orderIndex
            } else {
                let newHabit = Habit(from: draftHabit)
                routine.habits.append(newHabit)
            }
        }
    }
    
    func commit() {
        try? modelContext?.save()
        original = draft
    }
}

@Observable
class HabitViewModel {
    var selectedHabit: HabitDraft? = nil
    var newHabitTitle: String = ""
    var isHabitEntryPresented: Bool = false
    
    func resetHabitInput() {
        self.newHabitTitle = ""
        self.selectedHabit = nil
    }
}
