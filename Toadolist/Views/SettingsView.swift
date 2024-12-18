//
//  SettingsView.swift
//  Toadolist
//
//  Created by Paola Campanile on 09/12/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    @State private var enableNotifications = false
    @State private var darkMode = false
    @State private var fontSize: Double = 14
    @State private var selectedAppIcon: String? = nil
    @State private var enableSoundAndHaptics = true
    
    let appIcons = ["AppIcon1", "AppIcon2", "AppIcon3"] // Example app icons
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Preferences")) {
                    Toggle("Enable Notifications", isOn: $enableNotifications)
                    Toggle("Switch Mode", isOn: $darkMode)
                    
                    HStack {
                        Text("Font Size")
                        Slider(value: $fontSize, in: 10...20, step: 1) {
                            Text("Font Size")
                        }
                        Text("\(Int(fontSize)) pt")
                            .frame(width: 50, alignment: .trailing)
                    }
                }
                
                Section(header: Text("App Settings")) {
                    Picker("Select App Icon", selection: $selectedAppIcon) {
                        Text("Default").tag(String?.none)
                        ForEach(appIcons, id: \.self) { appIcon in
                            Text(appIcon).tag(String?.some(appIcon))
                        }
                    }
                    .onChange(of: selectedAppIcon) { newIcon, _ in
                        setAppIcon(newIcon)
                    }
                    
                    Toggle("Enable Sound & Haptics", isOn: $enableSoundAndHaptics)
                        .onChange(of: enableSoundAndHaptics) { newValue, _ in
                            
                        }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Close") {
                    isPresented = false
                }
                    .foregroundColor(.green)
            )
        }
    }
    
    func setAppIcon(_ iconName: String?) {
        if UIApplication.shared.supportsAlternateIcons {
            UIApplication.shared.setAlternateIconName(iconName) { error in
                if let error = error {
                    print("Error setting app icon: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    SettingsView(isPresented: .constant(true))
}
