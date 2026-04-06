//
//  FormAlertView.swift
//  Youtine!
//
//  Created by Bobby Guerra on 3/3/26.
//

import SwiftUI

struct FormAlertView: View {
    @Bindable var routineViewModel: RoutineViewModel
    @Bindable var habitViewModel: HabitViewModel
    
    var body: some View {
        TextField(text: $habitViewModel.newHabitTitle) {
            Text("Enter new habit")
        }
        
        HStack {
            Button("Cancel", role: .cancel) {
                habitViewModel.resetHabitInput()
            }
            
            Button("Confirm", role: .confirm) {
                if let selectedHabit = habitViewModel.selectedHabit,
                   let idx = routineViewModel.draft.habits.firstIndex(where: { $0.id == selectedHabit.id }) {
                    routineViewModel.draft.habits[idx].label = habitViewModel.newHabitTitle
                } else {
                    routineViewModel.addHabit(label: habitViewModel.newHabitTitle)
                }
                habitViewModel.resetHabitInput()
                
            }
            .disabled(habitViewModel.newHabitTitle.trimmingCharacters(in: .whitespaces).isEmpty)
        }
    }
}
