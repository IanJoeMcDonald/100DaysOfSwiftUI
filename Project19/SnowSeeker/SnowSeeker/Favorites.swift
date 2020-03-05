//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Masipack Eletronica on 05/03/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import Foundation

class Favorites: ObservableObject {
    // the actual resorts the user has favorites
    private var resorts: Set<String>
    
    // the key we're using to read/write in UserDefaults
    private let saveKey = "Favorites"
    
    init() {
        let location = Favorites.getDocumentsDirectory().appendingPathComponent(saveKey)
        
        if let data = try? Data(contentsOf: location) {
            if let decoded = try? JSONDecoder().decode([String].self, from: data) {
                self.resorts = Set<String>(decoded)
                return
            }
        }
        
        // still here? Use an empty array
        self.resorts = []
    }
    
    // returns true if our set contains this resort
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    // add the resort to our set, updates all views, and saves the cahnge
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    // removes the resort from our set, updates all views, and saves the change
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    private func save() {
        let location = Favorites.getDocumentsDirectory().appendingPathComponent(saveKey)
        
        do {
            let array: [String] = Array(resorts)
            let data = try JSONEncoder().encode(array)
            try data.write(to: location, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
