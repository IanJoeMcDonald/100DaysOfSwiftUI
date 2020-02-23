//
//  User.swift
//  MeetupFaces
//
//  Created by Masipack Eletronica on 22/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import Foundation

class User: Codable, Identifiable {
    var id: String
    var name: String
    var additional: String
    
    init(id: String, name: String = "", additional: String = "") {
        self.id = id
        self.name = name
        self.additional = additional
    }
}
