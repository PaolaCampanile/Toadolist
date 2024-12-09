//
//  TadpoleRowView.swift
//  Toadolist
//
//  Created by Paola Campanile on 09/12/24.
//

import SwiftUI

struct TadpoleRowView: View {
    @Binding var tadpole: Tadpole
    @Binding var isEditingMode: Bool
    var onDelete: () -> Void

    var body: some View {
        HStack {
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    tadpole.completed.toggle()
                }
                if tadpole.completed {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            onDelete()
                        }
                    }
                }
            } label: {
                Image(
                    systemName: tadpole.completed
                        ? "checkmark.circle.fill" : "circle"
                )
                .foregroundColor(tadpole.completed ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())

            if isEditingMode {
                VStack {
                    TextField("Tadpole", text: $tadpole.name)
                    TextField("Tadpole Description", text: $tadpole.description)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                VStack(alignment: .leading) {
                    Text(tadpole.name)
                        .font(.headline)
                    Text(tadpole.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .swipeActions {
            Button(role: .destructive) {
                withAnimation {
                    onDelete()
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

#Preview {
    TadpoleRowView(
        tadpole: .constant(
            Tadpole(
                name: "Tadpole",
                description: "Description",
                completed: true
            )
        ),
        isEditingMode: .constant(false),
        onDelete: {}
    )
}

#Preview {
    TadpoleRowView(
        tadpole: .constant(
            Tadpole(
                name: "Tadpole",
                description: "Description",
                completed: true)
        ),
        isEditingMode: .constant(true),
        onDelete: {}
    )
}
