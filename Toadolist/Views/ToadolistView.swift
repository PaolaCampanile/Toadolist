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
    @State private var currentToad: Toad = Toad(name: "", description: "", completed: false)
    @State private var isEditingMode = false
    @State private var toadOpacity: Double = 1.0 // Initial opacity
    @State private var toadCompleted: Bool = false // Track if toad is completed
    

    var body: some View {
        NavigationView {
            VStack {
                Image("SadFrog", label: Text("Sketch of a sad frog"))
                List {
                    toadSection
                    tadpoleSection
                }
                .navigationTitle("Toadolist")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                        Button {
                            if isEditingMode {
                                self.currentToad = Toad(name: toadName, description: toadDescription, completed: false)
                            }
                            isEditingMode.toggle()
                        } label: {
                            Text(isEditingMode ? "Done" : "Edit")
                                .foregroundColor(.green)
                        }
                        .disabled(tadpoles.isEmpty)
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
            if !currentToad.completed {
                ToadView(toad: $currentToad, tadpoles: $tadpoles)
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

