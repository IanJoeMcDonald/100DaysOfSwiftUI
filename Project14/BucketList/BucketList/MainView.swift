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
                        selectedPlace: $connections.selectedPlace,
                        showingPlaceDetails: $connections.showingPlaceDetails,
                        annotations: connections.locations)
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
                        // error
                    }
                }
            }
        } else {
            // no biometrics
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(connections: ContentViewConnections())
    }
}
