//
//  MainView.swift
//  BucketList
//
//  Created by Ian McDonald on 15/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI
import MapKit
import LocalAuthentication

struct MainView: View {
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var isUnlocked = false
    @ObservedObject var connections: ContentViewConnections
    
    
    var body: some View {
        ZStack {
            if isUnlocked {
                MapView(centerCoordinate: $centerCoordinate,
                        connections: connections)
                    .edgesIgnoringSafeArea(.all)
                Circle()
                    .fill(Color.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            let newLocation = CodableMKPointAnnotation()
                            newLocation.coordinate = self.centerCoordinate
                            newLocation.title = "Example location"
                            self.connections.locations.append(newLocation)
                            self.connections.selectedPlace = newLocation
                            self.connections.showingEditScreen = true
                        }) {
                            // Appearence is the same but now the whole image is clickable instead
                            // of just the plus symbol
                            Image(systemName: "plus")
                                .padding()
                                .background(Color.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                    }
                }
            } else {
                Button("Unlock Places") {
                    self.authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: reason) { success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.connections.alertTitle = "Failed to Authenticate"
                        self.connections.alertMessage = "Unable to authenticate you. Please try again"
                        self.connections.showingAlertSecondButton = false
                        self.connections.showingAlert = true
                    }
                }
            }
        } else {
            self.connections.alertTitle = "Authentication not available"
            self.connections.alertMessage = "Your device does not have biometric authentication."
            self.connections.showingAlertSecondButton = false
            self.isUnlocked = true
            self.connections.showingAlert = true
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(connections: ContentViewConnections())
    }
}
