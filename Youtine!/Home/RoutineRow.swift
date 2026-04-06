import SwiftUI

struct RoutineRow: View {
    let routine: Routine
    let darkDisplay: Bool
    let sortedHabits: [Habit]
    let allHabitsCompleted: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text(routine.title)
                .font(.system(size: 40, weight: .thin))
            Text("⏰: \(routine.start.formatted(date: .omitted, time: .shortened))")
                .lineLimit(1)
                .truncationMode(.tail)
            if let firstHabit = sortedHabits.first(where: { !$0.completed }) {
                Text("📋: \(firstHabit.label)")
                    .foregroundStyle(.yellow)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            HStack {
                HStack {
                    ForEach(sortedHabits) { habit in
                        Image(systemName: "checkmark")
                            .foregroundStyle(habit.completed ? .green : .red)
                    }
                }
                .padding(.top, 8)

                Spacer()

                Text("\(sortedHabits.filter { $0.completed }.count)/\(sortedHabits.count)")
                    .font(.system(size: 28))
                    .strikethrough(allHabitsCompleted, color: darkDisplay ? .white : .black)
            }
        }
        .blur(radius: allHabitsCompleted ? 2 : 0)
    }
}

#Preview("RoutineRow") {
    let habit1 = Habit(label: "Read", completed: true, orderIndex: 0)
    let habit2 = Habit(label: "Exercise", completed: false, orderIndex: 1)
    let routine = Routine(title: "Morning", start: .now, orderIndex: 0, habits: [habit1, habit2])
    return RoutineRow(
        routine: routine,
        darkDisplay: false,
        sortedHabits: [habit1, habit2],
        allHabitsCompleted: false
    )
}
