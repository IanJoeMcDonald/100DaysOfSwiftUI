//
//  UserView.swift
//  MeetupFaces
//
//  Created by Masipack Eletronica on 23/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct UserView: View {
    @State var user: User!
    @State private var name = ""
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "plus")
                TextField("Name", text: $name)
                TextField("Description", text: $description)
            }
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: User(id: UUID().uuidString, name: "Test"))
    }
}
