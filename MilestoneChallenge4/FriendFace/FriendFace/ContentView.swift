//
//  ContentView.swift
//  FriendFace
//
//  Created by Ian McDonald on 09/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var users = [User]()
    
    var body: some View {
        NavigationView {
            List(users) { user in
                NavigationLink(destination: UserDetailView(user: user, users: self.users)) {
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.headline)
                        Text(user.company)
                    }
                }
            }
            .navigationBarTitle("FriendFace")
            .onAppear(perform: {
                self.getUsersFromUrl("https://www.hackingwithswift.com/samples/friendface.json")
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
            
            self.users = loaded
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
