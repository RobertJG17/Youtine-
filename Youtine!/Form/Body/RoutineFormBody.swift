//
//  RoutineFormBody.swift
//  Youtine!
//
//  Created by Bobby Guerra on 2/26/26.
//

import SwiftUI
import TipKit

struct RoutineFormBody: View {
    @Bindable var routineViewModel: RoutineViewModel
    @Bindable var habitViewModel: HabitViewModel
        
    init(routineViewModel: RoutineViewModel, habitViewModel: HabitViewModel) {
        self.routineViewModel = routineViewModel
        self.habitViewModel = habitViewModel
    }
    
    var body: some View {
        VStack {
            DatePicker(selection: $routineViewModel.draft.start, displayedComponents: .hourAndMinute) {
                Text("Start Time")
                    .font(.system(size: 20, weight: .thin))
            }
            
            Divider()
                .padding(.vertical, 3)
            
            HStack {
                Text("Cadence")
                    .font(.system(size: 20, weight: .thin))
                Spacer()
                Picker("", selection: Binding(
                    get: { routineViewModel.draft.cadence },
                    set: { routineViewModel.draft.cadence = $0 }
                )) {
                    ForEach(Cadence.allCases, id: \.self) { cadence in
                        Text(cadence.rawValue.capitalized)
                            .tag(cadence)
                    }
                } currentValueLabel: {
                    Text(routineViewModel.draft.cadence.rawValue.capitalized)
                }
                
            }
            
            Divider()
                .padding(.vertical, 3)
            
            Text("Habits")
                .font(.system(size: 30, weight: .regular))
                .padding(.top, 20)
            
            Divider()
        }
        .padding([.horizontal, .top])
        
        if routineViewModel.draft.habits.isEmpty {
            Spacer()
            TipView(EmptyHabitTip(), arrowEdge: .bottom)
                .symbolRenderingMode(.multicolor)
                .padding(.horizontal)
                .animation(.easeIn, value: routineViewModel.draft.habits.isEmpty)
        } else {
            List {
                // TODO: Unpack habits from Routine that user navigated to
                ForEach(routineViewModel.draft.habits) { habit in
                    habitRow(habit)
                }
                .onMove(perform: routineViewModel.moveHabit)
            }
            .listStyle(.plain)
            .mask(
                LinearGradient(
                    stops: [
                        .init(color: .white, location: 0),
                        .init(color: .clear, location: 1),
                        .init(color: .clear, location: 2),
                        .init(color: .clear, location: 3)
                    ],
                    startPoint: .center, endPoint: .bottom
                )
                .ignoresSafeArea()
            )
        }
    }
    
    func habitRow(_ habit: HabitDraft) -> some View {
        HStack {
            Text(habit.label)
                .font(.system(size: 18, weight: .light))
                .padding(.vertical)
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        routineViewModel.deleteHabit(id: habit.id)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        let value = habit
                        habitViewModel.newHabitTitle = value.label
                        habitViewModel.selectedHabit = value
                        habitViewModel.isHabitEntryPresented.toggle()
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.yellow)
                }
            
            Spacer()
            
            Image(systemName: "minus.circle.fill")
                .foregroundStyle(.red)
                .onTapGesture { routineViewModel.deleteHabit(id: habit.id)}
        }
    }
}


#Preview {
    RoutineFormBody(routineViewModel: RoutineViewModel(routine: nil, index: 0), habitViewModel: HabitViewModel())
}

