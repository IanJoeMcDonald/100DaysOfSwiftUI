//
//  UsersStore+CoreDataProperties.swift
//  FriendFace
//
//  Created by Masipack Eletronica on 12/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//
//

import Foundation
import CoreData


extension UsersStore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UsersStore> {
        return NSFetchRequest<UsersStore>(entityName: "UsersStore")
    }

    @NSManaged public var id: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var comapny: String?
    @NSManaged public var email: String?
    @NSManaged public var address: String?
    @NSManaged public var about: String?
    @NSManaged public var registered: Date?
    @NSManaged public var tags: [String]?
    @NSManaged public var friends: NSSet?
    
    public var wrappedTags: [String] {
        tags ?? [String]()
    }
    
    public var wrappedRegistered: Date {
        registered ?? Date()
    }
    
    public var wrappedAbout: String {
        about ?? "Unknown About"
    }
    
    public var wrappedAddress: String {
        address ?? "Unknown Address"
    }
    
    public var wrappedEmail: String {
        email ?? "Unknown Email"
    }
    
    public var wrappedCompany: String {
        comapny ?? "Unknown Company"
    }
    
    public var wrappedAge: Int {
        Int(age)
    }
    
    public var wrappedName: String {
        name ?? "Unknown Name"
    }
    
    public var wrappedId: String {
        id ?? "Unknown Id"
    }
    
    public var friendsArray: [FriendsStore] {
        let set = friends as? Set<FriendsStore> ?? []
        return set.sorted {
            $0.wrappedId < $1.wrappedId
        }
    }
}

// MARK: Generated accessors for friends
extension UsersStore {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: FriendsStore)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: FriendsStore)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}
