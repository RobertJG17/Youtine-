//
//  RoutineForm.swift
//  Youtine!
//
//  Created by Bobby Guerra on 2/20/26.
//

import SwiftUI
import SwiftData
import Observation

struct RoutineForm: View {
    var routine: RoutineDraft?
    
    @State private var routineViewModel: RoutineViewModel
    @State private var habitViewModel: HabitViewModel
    @State private var showFormDiscardConfirmation: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    
    init(routine: Routine?, index: Int) {
        // when entering a form, we want to initialize a RoutineDraft form
        self.routineViewModel = RoutineViewModel(routine: routine, index: index)
        self.habitViewModel = HabitViewModel()
    }
    
    var isDisabled: Bool { !routineViewModel.hasChanges || routineViewModel.draft.title.isEmpty }
    
    func attemptDismiss() {
        if routineViewModel.hasChanges {
            showFormDiscardConfirmation.toggle()
        } else {
            dismiss()
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            TextField(text: $routineViewModel.draft.title) {
                Text("Routine Name")
            }
            .font(.system(size: 40, weight: .thin))
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .padding(.vertical, 8)
            
            Divider()
            
            RoutineFormBody(routineViewModel: routineViewModel, habitViewModel: habitViewModel)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    habitViewModel.isHabitEntryPresented.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    attemptDismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .confirmationDialog(
                    "Discard",
                    isPresented: $showFormDiscardConfirmation
                ) {
                    Button("Discard Changes?", role: .destructive) {
                        dismiss()
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    try? routineViewModel.saveRoutine()
                    dismiss()
                } label: {
                    Text("Save")
                }
                .tint(Color(.systemBlue))
                .disabled(isDisabled)
            }
        }
        .alert("New Habit", isPresented: $habitViewModel.isHabitEntryPresented) {
            FormAlertView(routineViewModel: routineViewModel, habitViewModel: habitViewModel)
        }
        .onAppear {
            routineViewModel.configure(with: modelContext)
        }
        .onDisappear {
            // reset draft back to original state when leaving form
            routineViewModel.draft = routineViewModel.original
        }
        .environment(\.formState, routineViewModel.formState)
    }
}


//#Preview {
//    RoutineForm(routine: nil)
//}
