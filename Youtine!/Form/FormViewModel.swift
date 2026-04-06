//
//  ViewModel.swift
//  Youtine!
//
//  Created by Bobby Guerra on 2/28/26.
//

import SwiftUI
import Observation

extension RoutineForm {
    @Observable
    class RoutineViewModel {
        let formState: FormState
        var draft: RoutineDraft
        
        // move hasChanges to here instead of passing view model thru to ViewModifier
        var hasChanges: Bool {
            // works if creating
            self.draft.title.trimmingCharacters(in: .whitespaces).count > 0 ||
            self.draft.habits.count > 0
            
            // if editing, title might already have chars and habits.count might be > 0
            // .onAppear -> capture initial data in another RoutineDraft RoutineDraft
            // .onChange of any fields in the viewModel, we compare the new value to the value in the initial data draft
            //
        }
        
        init(routine: Routine?) {
            if let routine {
                self.formState = .editing
                self.draft = RoutineDraft.init(from: routine)
            } else {
                self.formState = .creating
                self.draft = RoutineDraft.init()
            }
        }
        
        func addHabit(habit: HabitDraft) {
            withAnimation {
                habit.position = Double(draft.habits.count)
                draft.habits.append(habit)
            }
        }
        
        func deleteHabit(_ habit: HabitDraft) {
            withAnimation {
                draft.habits.removeAll(where: { $0.id == habit.id })
            }
        }
        
        func moveHabit(from source: IndexSet, to destination: Int) {
            self.draft.habits.move(fromOffsets: source, toOffset: destination)
            print("Source: ", source)
            print("Destination", destination)
        }
    }
    
    class HabitViewModel {
        
    }
}
