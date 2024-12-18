//
//  ToadolistView.swift
//  Toadolist
//
//  Created by Paola Campanile on 09/12/24.
//

import SwiftUI

struct ToadolistView: View {
    @StateObject private var taskManager = TaskManager()
    @State private var isModalPresented = false
    @State private var isSettingsPresented = false
    @State private var toadName = ""
    @State private var toadDescription = ""
    @State private var isEditingMode = false
    @State private var selectedDate = Date()
    @State private var isCalendarExpanded = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var dateRange: [Date] {
        let calendar = Calendar.current
        let today = Date()
        _ = calendar.date(byAdding: .day, value: -15, to: today) ?? today
        return (0..<30).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: today)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                CalendarView(
                    selectedDate: $selectedDate,
                    isCalendarExpanded: $isCalendarExpanded,
                    dates: dateRange
                )
                
                List {
                    toadSection
                    Image(colorScheme == .dark ? "SadToadLilyDark" : "SadToadLily")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 100)
                        .padding(.leading, -30)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                        .accessibilityLabel("A toad sitting on a lilypad")
                    
                    
                    tadpoleSection
                    Image(colorScheme == .dark ? "TadpolesBubbleDark" : "TadpolesBubble")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 150)
                        .padding(.leading, 110)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                        .accessibilityLabel("A group of tadpoles swimming through bubbles")
                }
                .navigationTitle("Toadolist")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(isEditingMode ? "Done" : "Edit") {
                            isEditingMode.toggle()
                        }
                        .tint(.green)
                        .disabled(taskManager.getTadpoles(for: selectedDate).isEmpty &&
                                  taskManager.getToad(for: selectedDate).name.isEmpty)
                    }
                    
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button {
                            isModalPresented = true
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.green)
                        }
                        Button {
                            isSettingsPresented = true
                        } label: {
                            Image(systemName: "gear")
                                .foregroundColor(.green)
                        }
                    }
                }
                .sheet(isPresented: $isModalPresented) {
                    AddToadOrTadpoleView(
                        isPresented: $isModalPresented,
                        toadName: $toadName,
                        toadDescription: $toadDescription,
                        tadpoles: .init(
                            get: { taskManager.getTadpoles(for: selectedDate) },
                            set: { taskManager.saveTasks(toad: taskManager.getToad(for: selectedDate), tadpoles: $0, for: selectedDate) }
                        ),
                        currentToad: .init(
                            get: { taskManager.getToad(for: selectedDate) },
                            set: { taskManager.saveTasks(toad: $0, tadpoles: taskManager.getTadpoles(for: selectedDate), for: selectedDate) }
                        ),
                        selectedDate: $selectedDate
                    )
                }
                .sheet(isPresented: $isSettingsPresented) {
                    SettingsView(isPresented: $isSettingsPresented)
                }
            }
        }
    }
    
    private var toadSection: some View {
        Section(header: Text("Toad of the day")) {
            Group {
                let currentToad = taskManager.getToad(for: selectedDate)
                if currentToad.name.isEmpty {
                    Button {
                        toadName = ""
                        toadDescription = ""
                        isModalPresented = true
                    } label: {
                        Text("Define your toad")
                            .accessibilityHint("Add your Toad")
                            .foregroundColor(.gray)
                    }
                } else if isEditingMode {
                    HStack {
                        VStack {
                            TextField("Toad Name", text: .init(
                                get: { currentToad.name },
                                set: { name in
                                    var updatedToad = currentToad
                                    updatedToad.name = name
                                    taskManager.saveTasks(
                                        toad: updatedToad,
                                        tadpoles: taskManager.getTadpoles(for: selectedDate),
                                        for: selectedDate
                                    )
                                }
                            ))
                            .textFieldStyle(.roundedBorder)
                            TextField("Toad Description", text: .init(
                                get: { currentToad.description },
                                set: { description in
                                    var updatedToad = currentToad
                                    updatedToad.description = description
                                    taskManager.saveTasks(
                                        toad: updatedToad,
                                        tadpoles: taskManager.getTadpoles(for: selectedDate),
                                        for: selectedDate
                                    )
                                }
                            ))
                            .textFieldStyle(.roundedBorder)
                        }
                        Button {
                            taskManager.saveTasks(
                                toad: Toad(name: "", description: "", completed: false),
                                tadpoles: taskManager.getTadpoles(for: selectedDate),
                                for: selectedDate
                            )
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                } else {
                    ToadView(
                        toad: .init(
                            get: { currentToad },
                            set: { taskManager.saveTasks(
                                toad: $0,
                                tadpoles: taskManager.getTadpoles(for: selectedDate),
                                for: selectedDate
                            )}
                        ),
                        tadpoles: .init(
                            get: { taskManager.getTadpoles(for: selectedDate) },
                            set: { taskManager.saveTasks(
                                toad: taskManager.getToad(for: selectedDate),
                                tadpoles: $0,
                                for: selectedDate
                            )}
                        )
                    )
                }
            }
        }
    }
    
    private var tadpoleSection: some View {
        Section(header: Text("Tadpoles of the day")) {
            let tadpoles = taskManager.getTadpoles(for: selectedDate)
            if tadpoles.isEmpty {
                Button {
                    toadName = ""
                    toadDescription = ""
                    isModalPresented = true
                } label: {
                    Text("Define your tadpoles")
                        .accessibilityHint("Add your Tadpoles")
                        .foregroundColor(.gray)
                }
            } else {
                ForEach(tadpoles.indices, id: \.self) { index in
                    if isEditingMode {
                        HStack {
                            TextField("Tadpole Name", text: .init(
                                get: { tadpoles[index].name },
                                set: { name in
                                    var updatedTadpoles = tadpoles
                                    updatedTadpoles[index].name = name
                                    taskManager.saveTasks(
                                        toad: taskManager.getToad(for: selectedDate),
                                        tadpoles: updatedTadpoles,
                                        for: selectedDate
                                    )
                                }
                            ))
                            .textFieldStyle(.roundedBorder)
                            TextField("Tadpole Description", text: .init(
                                get: { tadpoles[index].description },
                                set: { description in
                                    var updatedTadpoles = tadpoles
                                    updatedTadpoles[index].description = description
                                    taskManager.saveTasks(
                                        toad: taskManager.getToad(for: selectedDate),
                                        tadpoles: updatedTadpoles,
                                        for: selectedDate
                                    )
                                }
                            ))
                            .textFieldStyle(.roundedBorder)
                            Button {
                                var updatedTadpoles = tadpoles
                                updatedTadpoles.remove(at: index)
                                taskManager.saveTasks(
                                    toad: taskManager.getToad(for: selectedDate),
                                    tadpoles: updatedTadpoles,
                                    for: selectedDate
                                )
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    } else {
                        TadpoleRowView(
                            tadpole: .init(
                                get: { tadpoles[index] },
                                set: { updatedTadpole in
                                    var updatedTadpoles = tadpoles
                                    updatedTadpoles[index] = updatedTadpole
                                    taskManager.saveTasks(
                                        toad: taskManager.getToad(for: selectedDate),
                                        tadpoles: updatedTadpoles,
                                        for: selectedDate
                                    )
                                }
                            ),
                            isEditingMode: $isEditingMode
                        ) {
                            var updatedTadpoles = tadpoles
                            updatedTadpoles.remove(at: index)
                            taskManager.saveTasks(
                                toad: taskManager.getToad(for: selectedDate),
                                tadpoles: updatedTadpoles,
                                for: selectedDate
                            )
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ToadolistView()
}
