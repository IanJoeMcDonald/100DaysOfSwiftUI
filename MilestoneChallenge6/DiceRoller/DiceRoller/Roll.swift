//
//  Roll.swift
//  DiceRoller
//
//  Created by Masipack Eletronica on 05/03/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import Foundation

class Roll: Identifiable, Codable {
    let id = UUID()
    var numberOfSides = 6
    var result = 1
}

class Rolls: ObservableObject {
    @Published private(set) var list: [Roll]
    static let saveKey = "SavedData"
    
    init() {
        let filename = Rolls.getDocumentsDirectory().appendingPathComponent(Self.saveKey)
        
        if let data = try? Data(contentsOf: filename) {
            if let decoded = try? JSONDecoder().decode([Roll].self, from: data) {
                self.list = decoded
                return
            }
        }
        
        self.list = []
    }
    
    private func save() {
        do {
            let filename = Rolls.getDocumentsDirectory().appendingPathComponent(Self.saveKey)
            let data = try JSONEncoder().encode(list)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func add(_ roll: Roll) {
        list.insert(roll, at: 0)
        save()
    }
}
