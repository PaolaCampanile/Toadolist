//
//  OnBoarding.swift
//  Toadolist
//
//  Created by Paola Campanile on 16/12/24.
//

import SwiftUI

// Imports remain the same

struct OnBoarding: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Background color
            Color(UIColor.systemBackground).ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Buttons at bottom with more spacing
                HStack(spacing: 230) {
                    // Skip button
                    Button("Skip") {
                        dismiss()
                    }
                    .foregroundColor(.green)
                    Button {
                        // Action for next page
                    } label: {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.green)
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    OnBoarding()
}
