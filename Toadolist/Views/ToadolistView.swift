//
//  ToadolistView.swift
//  Toadolist
//
//  Created by Paola Campanile on 09/12/24.
//

import SwiftUI

struct ToadolistView: View {
    @State private var isModalPresented = false
    @State private var isSettingsPresented = false
    @State private var toadName = ""
    @State private var toadDescription = ""
    @State private var tadpoles: [Tadpole] = []
    @State private var currentToad: Toad? = nil
    @State private var isEditingMode = false
    @State private var toadOpacity: Double = 1.0 // Initial opacity
    @State private var toadCompleted: Bool = false // Track if toad is completed

    var body: some View {
        NavigationView {
            VStack {
                List {
                    toadSection
                    tadpoleSection
                }
                .navigationTitle("Toadolist")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            if isEditingMode {
                                self.currentToad = Toad(name: toadName, description: toadDescription, completed: false)
                            }
                            isEditingMode.toggle()
                        }) {
                            Text(isEditingMode ? "Done" : "Edit")
                                .foregroundColor(.green)
                        }
                        .disabled(currentToad == nil && tadpoles.isEmpty)
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            isModalPresented = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.green)
                        }
                        Button(action: {
                            isSettingsPresented = true
                        }) {
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
                        tadpoles: $tadpoles,
                        currentToad: $currentToad
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
            if let currentToad = currentToad, !toadCompleted {
                VStack(alignment: .leading) {
                    if isEditingMode {
                        TextField("Toad", text: $toadName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Toad Description", text: $toadDescription)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        Text(currentToad.name)
                            .font(.headline)
                            .strikethrough(toadOpacity == 0, color: .gray)
                            .opacity(toadOpacity)
                        Text(currentToad.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .strikethrough(toadOpacity == 0, color: .gray)
                            .opacity(toadOpacity)
                    }

                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            toadCompleted.toggle() // Mark as completed
                            if toadCompleted {
                                toadOpacity = 0 // Fade out toad when completed
                            } else {
                                toadOpacity = 1 // Reset to initial state
                            }
                        }
                    }) {
                        Text(toadCompleted ? "" : "Eat the Toad")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    .padding(.top, 8)

                    // Add Tadpole section after task is marked "done"
                    if toadCompleted {
                        TextField("New Tadpole", text: $toadName)
                        Button(action: {
                            if !toadName.isEmpty {
                                tadpoles.append(
                                    Tadpole(
                                        name: toadName,
                                            description: "New tadpole",
                                            completed: false
                                    )
                                )
                            }
                        }) {
                            Text("Add Tadpole")
                                .foregroundColor(.green)
                        }
                    }
                }
            } else {
                Text("Define your toad 🐸")
                    .foregroundColor(.gray)
            }
        }
    }

    private var tadpoleSection: some View {
        Section(header: Text("Tadpoles of the day")) {
            if tadpoles.isEmpty {
                Text("Define your tadpoles 🪷")
                    .foregroundColor(.gray)
            } else {
                ForEach(tadpoles.indices, id: \.self) { index in
                    TadpoleRowView(
                        tadpole: $tadpoles[index],
                        isEditingMode: $isEditingMode
                    ) {
                        tadpoles.remove(at: index)
                    }
                }
            }
        }
    }
}

#Preview {
    ToadolistView()
}

