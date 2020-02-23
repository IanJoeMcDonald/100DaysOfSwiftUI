//
//  Users.swift
//  MeetupFaces
//
//  Created by Masipack Eletronica on 23/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import Foundation

class Users: ObservableObject {
    @Published var list = [User]()
}
