//
//  UserDetailView.swift
//  FriendFace
//
//  Created by Ian McDonald on 09/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct UserDetailView: View {
    let user: UsersStore
    @FetchRequest(entity: UsersStore.entity(), sortDescriptors: []) var users: FetchedResults<UsersStore>
    var friends: [UsersStore] {
        var matches = [UsersStore]()
        
        for friend in user.friendsArray {
            if let match = users.first(where: {$0.wrappedId == friend.wrappedId}) {
                matches.append(match)
            } else {
                fatalError("Friend \(friend)")
            }
        }
        
        return matches
    }
    
    var body: some View {
        GeometryReader { gemoetry in
            ScrollView(.vertical) {
                VStack {
                    VStack(alignment: .leading) {
                        Text(self.user.wrappedName)
                        .font(.title)
                            .padding()
                        HStack(alignment: .top, spacing: 10) {
                            VStack(alignment: .leading) {
                                Text("Company: ")
                                Text("Email: ")
                                Text("Age: ")
                                Text("Address: " + self.user.wrappedAddress.newLineCharacters(of: ", "))
                                Text("Tags: ")
                            }
                            VStack(alignment: .leading) {
                                Text(self.user.wrappedCompany)
                                Text(self.user.wrappedEmail)
                                Text("\(self.user.wrappedAge)")
                                Text(self.user.wrappedAddress.replacingOccurrences(of: ", ", with: "\n"))
                                Text(self.user.wrappedTags.joined(separator: ", "))
                            }
                        }
                    }
                    .frame(width: gemoetry.size.width * 0.9)
                    .clipShape(RoundedRectangle(cornerRadius: CGFloat(10)))
                    .overlay(RoundedRectangle(cornerRadius: CGFloat(10))
                    .stroke(self.user.isActive ? Color.green : Color.gray, lineWidth: CGFloat(1)))
                    .padding()
                    
                    
                    VStack(alignment:.center, spacing: 5) {
                        Text("Friends")
                            .font(.title)
                            .padding(.horizontal)
                        ForEach(self.friends, id: \.self) { friend in
                            NavigationLink(destination: UserDetailView(user: friend)) {
                                                                        Text(friend.wrappedName)
                                                                            .padding(.horizontal)
                            }.padding(.horizontal)
                        }
                    }
                    .frame(width: gemoetry.size.width * 0.9)
                    .clipShape(RoundedRectangle(cornerRadius: CGFloat(10)))
                    .overlay(RoundedRectangle(cornerRadius: CGFloat(10))
                    .stroke(self.user.isActive ? Color.green : Color.gray, lineWidth: CGFloat(1)))
                    .padding()
                    
                    Spacer()
                }
            }.navigationBarTitle(Text(self.user.wrappedName), displayMode: .inline)
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    
    static let users = [UsersStore]()
    
    static var previews: some View {
        UserDetailView(user: users[0])
    }
}
