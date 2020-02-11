//
//  User.swift
//  FriendFace
//
//  Created by Ian McDonald on 09/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import Foundation

struct User: Codable, Identifiable {
    struct Friend: Codable {
        var id: String
        var name: String
    }
    var id: String
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    var friends: [Friend]
}
