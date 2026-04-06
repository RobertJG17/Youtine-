//
//  RoutineDetailView.swift
//  Youtine!
//
//  Created by Bobby Guerra on 3/3/26.
//

import SwiftUI

struct RoutineDetailView: View {
    let routine: Routine
    
    @State var isRoutineFormPresented: Bool = false
    
    @Environment(\.path) var path: Binding<[Route]>
    
    init(routine: Routine) {
        self.routine = routine
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            Text(routine.title)
                .font(.system(size: 40, weight: .thin))
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .padding()
            
            Divider()
                
            VStack {
                HStack {
                    Text("Start Time")
                        .font(.system(size: 20, weight: .thin))
                    
                    Spacer()
                    
                    Text(routine.start.formatted(date: .omitted, time: .shortened))
                        .font(.system(size: 20, weight: .thin))
                }
                
                Divider()
                    .padding(.vertical, 3)
                
                Text("Habits")
                    .font(.system(size: 30, weight: .thin))
                    .padding(.top, 20)
                
                Divider()
            }
            .padding([.horizontal, .top])
            
            ScrollView {
                // TODO: Unpack habits from Routine that user navigated to
                ForEach(routine.habits.sorted { $0.orderIndex < $1.orderIndex } ) { habit in
                    HabitCard(habit: habit)
                        .padding(24)
                    
                    Divider()
                }
            }
            .padding(.horizontal, 10)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    RoutineForm(routine: routine)
                        .onAppear {
                            path.wrappedValue.append(.view(routine))
                        }
                } label: {
                    Text("Edit")
                }
            }
        }
    }
}


struct HabitCard: View {
    var habit: Habit
    
    @Environment(\.formState) var formState
    
    init(habit: Habit) {
        self.habit = habit
    }
    
    var body: some View {
        HStack {
            Text(habit.label)
                .font(.system(size: 18, weight: .light))
     
            Spacer()
            
            Divider()
                .padding(.horizontal)
            
            Image(systemName: habit.completed ? "checkmark.circle.fill" : "circle")
                .onTapGesture {
                    habit.completed.toggle()
                }
        }
    }
}
