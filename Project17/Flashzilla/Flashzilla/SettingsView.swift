//
//  SettingsView.swift
//  Flashzilla
//
//  Created by Masipack Eletronica on 27/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationView {
            Toggle(isOn: $settings.replaceIncorrectAnswers) {
                Text("Replace incorrectly answered cards back into the pile")
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Exit", action: dismiss))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
