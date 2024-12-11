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
//                Image("SadFrog", label: Text("Sketch of a sad frog"))
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 100, height: 100)
//                    .padding(.trailing, 260)
                
                List {
                    toadSection
                    tadpoleSection
                }
                .navigationTitle(Text("Toadolist").font(.system(.largeTitle, design: .rounded))) // Rounded title
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            isEditingMode.toggle()
                        } label: {
                            Text(isEditingMode ? "Done" : "Edit")
                                .tint(Color.green)
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
                if currentToad.name.isEmpty || currentToad.completed {
                    Text("Define your toad 🐸")
                        .foregroundColor(.gray)
                    .onAppear {
                        if currentToad.completed {
                            currentToad = Toad(name: "", description: "", completed: true)
                        }
                    }
                } else {
                    if isEditingMode {
                        VStack {
                            TextField("Toad Name", text: $currentToad.name)
                                .textFieldStyle(.roundedBorder)
                            TextField("Toad Description", text: $currentToad.description)
                                .textFieldStyle(.roundedBorder)
                        }
                    } else {
                        VStack(alignment: .leading) {
                            ToadView(toad: $currentToad, tadpoles: $tadpoles)
                            Button("Eat your toad") {
                                currentToad.completed = true
                            }
                            .padding(.top, 8)
                            .foregroundColor(.green)
                        }
                    }
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
                    if isEditingMode {
                        // Editable tadpole fields
                        HStack {
                            TextField("Tadpole Name", text: $tadpoles[index].name)
                                .textFieldStyle(.roundedBorder)
                            TextField("Tadpole Description", text: $tadpoles[index].description)
                                .textFieldStyle(.roundedBorder)
                            Button(action: {
                                tadpoles.remove(at: index)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    } else {
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
}

#Preview {
    ToadolistView()
}
