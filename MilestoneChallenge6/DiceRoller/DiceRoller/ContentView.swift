//
//  ContentView.swift
//  DiceRoller
//
//  Created by Ian McDonald on 04/03/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var rolls = Rolls()
    
    var body: some View {
        TabView {
            RollerView()
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Roll")
            }
            HistoryView()
                .tabItem {
                    Image(systemName: "memories")
                    Text("History")
            }
        }
        .environmentObject(rolls)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
