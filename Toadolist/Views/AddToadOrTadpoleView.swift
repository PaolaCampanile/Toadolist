//
//  AddToadOrTadpoleView.swift
//  Toadolist
//
//  Created by Paola Campanile on 09/12/24.
//

import SwiftUI

struct AddToadOrTadpoleView: View {
    @Binding var isPresented: Bool
    @Binding var toadName: String
    @Binding var toadDescription: String
    @Binding var tadpoles: [Tadpole]
    @Binding var currentToad: Toad
    @Binding var selectedDate: Date
    
    @State private var newTadpoleName = ""
    @State private var newTadpoleDescription = ""
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("Add New Toad")) {
                    TextField("Toad", text: $toadName)
                    TextField("Toad Description (Optional)", text: $toadDescription)
                }
                
                Section(header: Text("Add New Tadpole")) {
                    TextField("Tadpole", text: $newTadpoleName)
                    TextField("Tadpole Description (Optional)", text: $newTadpoleDescription)
                    Button(action: {
                        if !newTadpoleName.isEmpty {
                            tadpoles.append(Tadpole(
                                name: newTadpoleName,
                                description: newTadpoleDescription,
                                completed: false
                            ))
                            newTadpoleName = ""
                            newTadpoleDescription = ""
                        }
                    }) {
                        Text("Add Tadpole")
                            .foregroundColor(.green)
                    }
                }
                
                Section(header: Text("Tadpoles Added")) {
                    ForEach(tadpoles, id: \.name) { tadpole in
                        VStack(alignment: .leading) {
                            Text(tadpole.name).font(.headline)
                            if !tadpole.description.isEmpty {
                                Text(tadpole.description).font(.subheadline)
                            }
                        }
                    }
                }
                Section(header: Text("Select a Date")) {
                    DatePicker(
                        "",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .frame(height: 300)
                    .accentColor(.green)
                }
                
            }
            .navigationBarTitle("Add Toad and Tadpoles", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                }
                    .foregroundColor(.green),
                trailing: Button("Save") {
                    if !toadName.isEmpty {
                        currentToad = Toad(
                            name: toadName,
                            description: toadDescription,
                            completed: false
                        )
                    }
                    isPresented = false
                }
                    .foregroundColor(.green)
            )
        }
    }
}

#Preview {
    AddToadOrTadpoleView(
        isPresented: .constant(true),
        toadName: .constant("Toad"),
        toadDescription: .constant("Description"),
        tadpoles: .constant([
            Tadpole(name: "Tadpole", description: "Description", completed: true)
        ]),
        currentToad: .constant(Toad(name: "Toad", description: "Description", completed: true)),
        selectedDate: .constant(Date())
    )
}
