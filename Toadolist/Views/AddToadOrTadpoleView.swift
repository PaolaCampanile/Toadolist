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

    @State private var newTadpoleName = ""
    @State private var newTadpoleDescription = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Add New Toad")) {
                    TextField("Toad", text: $toadName)
                    TextField("Toad Description", text: $toadDescription)
                }

                Section(header: Text("Add New Tadpole")) {
                    TextField("Tadpole", text: $newTadpoleName)
                    TextField(
                        "Tadpole Description", text: $newTadpoleDescription)
                    Button(action: {
                        if !newTadpoleName.isEmpty
                            && !newTadpoleDescription.isEmpty
                        {
                            tadpoles.append(
                                Tadpole(
                                    name: newTadpoleName,
                                    description: newTadpoleDescription,
                                    completed: false
                                )
                            )
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
                            Text(tadpole.description).font(.subheadline)
                        }
                    }
                }
            }
            .navigationBarTitle(
                "Add your Toad and Tadpole", displayMode: .inline
            )
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                }
                .foregroundColor(.green),
                trailing: Button("Save") {
                    if !toadName.isEmpty && !toadDescription.isEmpty {
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
        toadDescription: .constant("Descrption"),
        tadpoles: .constant([
            Tadpole(name: "Tadpole", description: "Description", completed: true)
        ]),
        currentToad: .constant(Toad(name: "Toad", description: "Description", completed: false))
    )
}
