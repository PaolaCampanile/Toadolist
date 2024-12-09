//
//  ToadView.swift
//  Toadolist
//
//  Created by Paola Campanile on 09/12/24.
//

import SwiftUI

struct ToadView: View {
    @Binding var toad: Toad
    @Binding var tadpoles: [Tadpole]
    @State private var isEditingMode = false

    var body: some View {
        VStack(alignment: .leading) {
            if isEditingMode {
                TextField("Toad", text: $toad.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Toad Description", text: $toad.description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text(toad.name)
                    .font(.headline)
                Text(toad.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    toad.completed.toggle()  // Mark as completed
                }
            } label: {
                Text(toad.completed ? "" : "Eat the Toad")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .padding(.top, 8)

            // Add Tadpole section after task is marked "done"
            if toad.completed {
                TextField("New Tadpole", text: $toad.name)
                Button {
                    if !toad.name.isEmpty {
                        tadpoles.append(
                            Tadpole(
                                name: toad.name,
                                description: "New tadpole",
                                completed: false
                            )
                        )
                    }
                } label: {
                    Text("Add Tadpole")
                        .foregroundColor(.green)
                }
            }
        }

    }
}

#Preview {
    ToadView(
        toad: .constant(
            Toad(
                name: "Toad",
                description: "Description",
                completed: false)
        ),
        tadpoles: .constant([
            Tadpole(
                name: "Tadpole",
                description: "Description",
                completed: false
            )
        ])
    )
}
