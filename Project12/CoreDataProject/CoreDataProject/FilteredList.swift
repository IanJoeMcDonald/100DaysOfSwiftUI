//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Ian McDonald on 27/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct FilteredList: View {
    var fetchRequest: FetchRequest<Singer>
    
    init(filter: String) {
        fetchRequest = FetchRequest<Singer>(entity: Singer.entity(), sortDescriptors: [], predicate: NSPredicate(format: "lastName BEGINSWITH %@", filter))
    }
    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { singer in
            Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
        }
    }
}

struct FilteredList_Previews: PreviewProvider {
    static var previews: some View {
        FilteredList(filter: "A")
    }
}
