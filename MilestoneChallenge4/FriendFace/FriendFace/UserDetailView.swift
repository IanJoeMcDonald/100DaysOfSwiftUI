//
//  UserDetailView.swift
//  FriendFace
//
//  Created by Ian McDonald on 09/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct UserDetailView: View {
    let user: User
    let users: [User]
    let friends: [User]
    
    var body: some View {
        GeometryReader { gemoetry in
            ScrollView(.vertical) {
                VStack {
                    VStack(alignment: .leading) {
                        Text(self.user.name)
                        .font(.title)
                            .padding()
                        HStack(alignment: .top, spacing: 10) {
                            VStack(alignment: .leading) {
                                Text("Company: ")
                                Text("Email: ")
                                Text("Age: ")
                                Text("Address: " + self.user.address.newLineCharacters(of: ", "))
                                Text("Tags: ")
                            }
                            VStack(alignment: .leading) {
                                Text(self.user.company)
                                Text(self.user.email)
                                Text("\(self.user.age)")
                                Text(self.user.address.replacingOccurrences(of: ", ", with: "\n"))
                                Text(self.user.tags.joined(separator: ", "))
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
                        ForEach(self.friends) { friend in
                            NavigationLink(destination: UserDetailView(user: friend,
                                                                       users: self.users)) {
                                                                        Text(friend.name)
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
            }.navigationBarTitle(Text(self.user.name), displayMode: .inline)
        }
    }
    
    init(user: User, users: [User]) {
        self.user = user
        self.users = users
        
        var matches = [User]()
        
        for friend in user.friends {
            if let match = users.first(where: {$0.id == friend.id}) {
                matches.append(match)
            } else {
                fatalError("Friend \(friend)")
            }
        }
        
        self.friends = matches
    }
}

struct UserDetailView_Previews: PreviewProvider {
    
    static let users = [User]()
    
    static var previews: some View {
        UserDetailView(user: users[0], users: users)
    }
}
