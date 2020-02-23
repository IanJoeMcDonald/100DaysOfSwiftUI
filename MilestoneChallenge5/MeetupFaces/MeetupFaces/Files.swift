//
//  Files.swift
//  MeetupFaces
//
//  Created by Masipack Eletronica on 23/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit
import SwiftUI

struct LoadSave {
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveUsers(_ users: Users) {
        do {
            let filename = getDocumentsDirectory().appendingPathComponent("SavedUsers")
            let data = try JSONEncoder().encode(users.list)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    func loadUsers() -> [User]? {
        let filename = LoadSave().getDocumentsDirectory().appendingPathComponent("SavedUsers")
        
        do {
            let data = try Data(contentsOf: filename)
            return try JSONDecoder().decode([User].self, from: data)
        } catch {
            print("Unable to load saved data.")
        }
        return nil
    }
    
    func saveImage(_ image: UIImage?, forID id : String) {
        if let jpegData = image?.jpegData(compressionQuality: 0.8) {
            do {
                let filename = getDocumentsDirectory().appendingPathComponent(id)
                try jpegData.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Unable to save photo")
            }
        }
    }
    
   func loadUIImage(uuid: String) -> UIImage? {
        let filename = getDocumentsDirectory().appendingPathComponent(uuid)
        
        do {
            let data = try Data(contentsOf: filename)
            return UIImage(data: data)
        } catch {
            print("Unable to load saved image.")
        }
        return nil
    }
    
    func loadImage(uuid: String) -> Image {
        if let image = loadUIImage(uuid: uuid) {
            return Image(uiImage: image)
        }
            
        return Image(systemName: "questionmark.circle.fill")
    }
}
