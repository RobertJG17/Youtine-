struct RoutineFormBody: View {
    let formState: FormState
    @Binding var viewModel: RoutineForm.ViewModel
        
    init(formState: FormState, viewModel: Binding<RoutineForm.ViewModel>) {
        self.formState = formState
        self._viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            DatePicker(selection: $viewModel.timeSelection, displayedComponents: .hourAndMinute) {
                Text("Start Time")
                    .font(.system(size: 20, weight: .thin))
            }
            
            Divider()
                .padding(.vertical, 3)
            
            HStack {
                Text("Cadence")
                    .font(.system(size: 20, weight: .thin))
                
                Spacer()
                
                Picker("", selection: $viewModel.cadence) {
                    Text("Daily").tag(Cadence.daily)
                    Text("Weekly").tag(Cadence.weekly)
                    Text("Monthly").tag(Cadence.monthly)
                }
            }
            
            Divider()
                .padding(.vertical, 2)
                              
            Text("Habits")
                .font(.system(size: 30, weight: .thin))
                .padding(.top, 20)
        }
        .padding()
     
        List {
            // TODO: Unpack habits from Routine that user navigated to
            ForEach(viewModel.habits) { habit in
                HabitCard(habit: habit)
                    .padding()
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel.deleteHabit(habit)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            viewModel.newHabitTitle = habit.label
                            viewModel.selectedHabit = habit
                            viewModel.isHabitEntryPresented.toggle()
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.yellow)
                    }
            }
        }
        .listStyle(.plain)
        .scrollEdgeEffectStyle(.automatic, for: .bottom)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    viewModel.isHabitEntryPresented.toggle()
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .background(
            Rectangle()
                .foregroundStyle(.white)
                .shadow(color: .gray, radius: 1, x: 0, y: 0)
        )
    }
}