//
//  ContentView.swift
//  BucketList
//
//  Created by Ian McDonald on 13/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var connections = ContentViewConnections()
    
    var body: some View {
        MainView(connections: connections)
            .alert(isPresented: $connections.showingAlert) {
                if connections.showingAlertSecondButton {
                    return Alert(title: Text(connections.alertTitle),
                                 message: Text(connections.alertMessage),
                                 primaryButton: .default(Text("OK")),
                                 secondaryButton: .default(Text("Edit")) {
                                self.connections.showingEditScreen = true
                    })
                } else {
                    return Alert(title: Text(connections.alertTitle),
                          message: Text(connections.alertMessage),
                          dismissButton: .default(Text("OK")))
                }
        }
        .sheet(isPresented: $connections.showingEditScreen, onDismiss: saveData) {
            if self.connections.selectedPlace != nil {
                EditView(placemark: self.connections.selectedPlace!)
            }
        }
        .onAppear(perform: loadData)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadData() {
        let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
        
        do {
            let data = try Data(contentsOf: filename)
            connections.locations = try JSONDecoder().decode([CodableMKPointAnnotation].self,
                                                             from: data)
        } catch {
            print("Unable to load saved data.")
        }
    }
    
    func saveData() {
        do {
            let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
            let data = try JSONEncoder().encode(self.connections.locations)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
