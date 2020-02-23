//
//  ContentView.swift
//  MeetupFaces
//
//  Created by Masipack Eletronica on 22/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var users = Users()
    @State private var tempImage: UIImage!
    @State private var showingAddPerson = false
    var initialDataLoaded = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users.list) { user in
                    NavigationLink(destination: AddView(users: self.users, uuid: user.id)) {
                        HStack {
                            LoadSave().loadImage(uuid: user.id)
                                .resizable()
                                    .frame(width: 83, height: 60)
                                .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                            Text(user.name)
                        }
                    }
                }
            .onDelete(perform: removeUsers)
            }
            .navigationBarTitle(Text("MeetupFaces"))
            .navigationBarItems(trailing: Button(action: { self.showingAddPerson = true }) {
                Image(systemName: "plus")
                    .font(.title)
                    .padding()
            })
            .sheet(isPresented: $showingAddPerson) {
                AddView(users: self.users, uuid: nil)
            }
            .onAppear(perform: loadData)
        }
    }
    
    func removeUsers(at offsets: IndexSet) {
        users.list.remove(atOffsets: offsets)
        LoadSave().saveUsers(users)
    }
    
    func loadData() {
        if !initialDataLoaded {
            if let loadedUsers = LoadSave().loadUsers() {
                users.list = loadedUsers
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
