//
//  ContentView.swift
//  FriendFace
//
//  Created by Ian McDonald on 09/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: UsersStore.entity(), sortDescriptors: []) var users: FetchedResults<UsersStore>
    @State private var gotDataFromUrl = false
    
    var body: some View {
        NavigationView {
            List(users, id: \.self) { user in
                NavigationLink(destination: UserDetailView(user: user)) {
                    VStack(alignment: .leading) {
                        Text(user.wrappedName)
                            .font(.headline)
                        Text(user.wrappedCompany)
                    }
                }
            }
            .navigationBarTitle("FriendFace")
            .onAppear(perform: {
                if !self.gotDataFromUrl {
                    self.getUsersFromUrl("https://www.hackingwithswift.com/samples/friendface.json")
                }
                self.gotDataFromUrl = true
            })
        }
    }
    
    func getUsersFromUrl(_ url: String) {
        
        guard let url = URL(string: url) else {
            fatalError("Failed to create url from passed string")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                fatalError("Failed to get data from URL")
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            guard let loaded = try? decoder.decode([User].self, from: data) else {
                fatalError("Failed to decode type from URL")
            }
            
            for user in loaded {
                let entity = UsersStore(context: self.moc)
                entity.id = user.id
                entity.isActive = user.isActive
                entity.name = user.name
                entity.age = Int16(user.age)
                entity.comapny = user.company
                entity.email = user.email
                entity.address = user.address
                entity.about = user.about
                entity.registered = user.registered
                entity.tags = user.tags
                for friend in user.friends {
                    let friendEntity = FriendsStore(context: self.moc)
                    friendEntity.id = friend.id
                    friendEntity.name = friend.name
                    friendEntity.user = entity
                }
                try? self.moc.save()
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
