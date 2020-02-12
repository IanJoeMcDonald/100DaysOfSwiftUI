//
//  FriendsStore+CoreDataProperties.swift
//  FriendFace
//
//  Created by Masipack Eletronica on 12/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//
//

import Foundation
import CoreData


extension FriendsStore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendsStore> {
        return NSFetchRequest<FriendsStore>(entityName: "FriendsStore")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var user: UsersStore?
    
    public var wrappedId: String {
        id ?? "Unknown Id"
    }
    
    public var wrappedName: String {
        name ?? "Unknown Name"
    }
}
