//
//  RoutineDetailView.swift
//  Youtine!
//
//  Created by Bobby Guerra on 3/3/26.
//

import SwiftUI
import UIKit

struct RoutineDetailView: View {
    let routine: Routine
    
    @State var isRoutineFormPresented: Bool = false
    
    init(routine: Routine) {
        self.routine = routine
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            Text(routine.title)
                .font(.system(size: 40, weight: .thin))
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .padding(.vertical, 8)
            
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
                
                HStack {
                    Text("Cadence")
                        .font(.system(size: 20, weight: .thin))
                    Spacer()
                    
                    Text(routine.cadence.capitalized)
                        .font(.system(size: 20, weight: .thin))
                }
                
                Divider()
                    .padding(.vertical, 3)
                
                Text("Habits")
                    .font(.system(size: 30, weight: .regular))
                    .padding(.top, 20)
                
                Divider()
            }
            .padding([.horizontal, .top])
            
            ScrollView {
                // TODO: Unpack habits from Routine that user navigated to
                ForEach(routine.habits.sorted { $0.orderIndex < $1.orderIndex } ) { habit in
                    HabitCard(habit: habit)
                        .padding(18)
                        .scrollTransition { content, phase in
                            return content
                                .blur(radius: phase == .identity ? 0 : 1)
                                .opacity(phase == .identity ? 1 : 0.3)
                        }
                    
                    Divider()
                }
            }
            .padding(.horizontal, 10)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: Route.edit(routine)) {
                    Text("Edit")
                }
            }
        }
    }
}


struct HabitCard: View {
    @AppStorage("darkDisplay") var darkDisplay: Bool = false

    var habit: Habit
    
    init(habit: Habit) {
        self.habit = habit
    }
    
    func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Text(habit.label)
                .font(.system(size: 18, weight: .light))
                .strikethrough(habit.completed, color: darkDisplay ? .white : .black)
                .animation(.easeIn, value: habit.completed)
            
            Spacer()
            
            Divider()
                .padding(.horizontal)
            
            Image(systemName: habit.completed ? "checkmark.circle.fill" : "circle")
                .animation(.bouncy, value: habit.completed)
        }
        .onChange(of: darkDisplay, { oldValue, newValue in
            print("Dark display?: ", newValue)
        })
        .contentShape(Rectangle())
        .onTapGesture {
            triggerHaptic()
            habit.completed.toggle()
            habit.lastCompleted = .now
        }
    }
}
