//
//  ContentView.swift
//  Youtine!
//
//  Created by Bobby Guerra on 2/19/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \Routine.orderIndex) var persistedRoutines: [Routine]
    
    @State private var path: [Route] = []
    
    @Environment(\.modelContext) private var modelContext
    
    /// neat little wrapper that sets a default for a user preference key and uses user preferences under the hood for persistence
    @AppStorage("darkDisplay") private var darkDisplay: Bool = false
    
    private func allHabitsCompleted(routine: Routine) -> Bool {
        routine.habits.filter({$0.completed}).count == routine.habits.count
    }
    
    private func isCompletedToday(_ habit: Habit) -> Bool {
        guard let last = habit.lastCompleted else { return false }
        return Calendar.current.isDateInToday(last)
    }
    
    private func deleteRoutine(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(persistedRoutines[index])
                NotificationsService.shared.deleteNotification(id: persistedRoutines[index].id.uuidString)
            }
        }
    }
    
    // MARK: - Computed & Helper Properties
    
    private func sortedHabits(for routine: Routine) -> [Habit] {
        routine.habits.sorted { $0.orderIndex < $1.orderIndex }
    }
    
    // MARK: - HeaderView Subview
    
    private func HeaderView(width: CGFloat) -> some View {
        Text("Youtine!")
            .font(.system(size: 48, weight: .ultraLight, design: .rounded))
            .underline(pattern: .solid)
            .accessibilityAddTraits(.isHeader)
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { proxy in
                VStack {
                    HeaderView(width: proxy.size.width)
                    
                    List {
                        Section {
                            ForEach(persistedRoutines) { routine in
                                NavigationLink(value: Route.view(routine)) {
                                    RoutineRow(
                                        routine: routine,
                                        darkDisplay: darkDisplay,
                                        sortedHabits: sortedHabits(for: routine),
                                        allHabitsCompleted: allHabitsCompleted(routine: routine)
                                    )
                                }
                            }
                            .onMove { fromOffsets, toOffset in
                                var routines = persistedRoutines
                                routines.move(fromOffsets: fromOffsets, toOffset: toOffset)
                                
                                for (index, routine) in routines.enumerated() {
                                    routine.orderIndex = index
                                }
                            }
                            .onDelete(perform: deleteRoutine)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        Rectangle()
                            .foregroundStyle(darkDisplay ? .gray.opacity(0.3) : .white)
                            .padding(2)
                    )
                    .listStyle(.plain)
                    .environment(\.defaultMinListRowHeight, 150)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .view(let routine):
                            RoutineDetailView(routine: routine)
                        case .create:
                            RoutineForm(routine: nil, index: persistedRoutines.count)
                        case .edit(let routine):
                            RoutineForm(routine: routine, index: routine.orderIndex)
                        }
                    }
                }
                // create mask so routines blur / lose opacity as they scroll over toolbar
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        NavigationLink(value: Route.create) {
                            Label("Add Routine", systemImage: "plus")
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            Form {
                                HStack {
                                    Text("Display mode:")
                                        .padding(.horizontal, 16)
                                    Picker("Display Mode", selection: $darkDisplay) {
                                        Image(systemName: "sun.max")
                                            .tag(false)
                                        Image(systemName: "moon.stars")
                                            .tag(true)
                                    }
                                    .pickerStyle(.segmented)
                                }
                                .navigationTitle("Settings")
                            }

                        } label: {
                            Image(systemName: "gear")
                        }
                    }
                }
            }
        }
        .onAppear { NotificationsService.promptNotificationsGrant() }
        .preferredColorScheme(darkDisplay ? .dark : .light)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Routine.self, Habit.self], inMemory: true)
}
