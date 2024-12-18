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
            VStack(alignment: .leading, spacing: 2) {
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
            }
            .padding(.bottom, 2)
            
            HStack {
                Spacer()
                Button(toad.completed ? "Was it tasty?" : "Eat the toad!") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        toad.completed = true
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .cornerRadius(32)
                .font(.headline)
                .tint(toad.completed ? .gray : .black)
                .disabled(toad.completed)
                Spacer()
            }
            .padding(.vertical, 2)
        }
        .padding(4)
    }
}

#Preview {
    ToadView(
        toad: .constant(Toad(name: "Test Toad", description: "Test Description", completed: false)),
        tadpoles: .constant([])
    )
    .padding()
    .background(Color(.systemBackground))
}
