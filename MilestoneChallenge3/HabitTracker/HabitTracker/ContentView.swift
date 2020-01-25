//
//  ContentView.swift
//  HabitTracker
//
//  Created by Ian McDonald on 25/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var habitList = Habits()
    @State private var showingAddHabit = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habitList.habits) { habit in
                    NavigationLink(destination: DetailView(habitList: self.habitList, index: self.habitList.habits.firstIndex(where: { $0.id == habit.id }) ?? 0)) {
                        Text(habit.title)
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("Habit Tracker")
            .navigationBarItems(trailing:
                Button(action: {
                    self.showingAddHabit = true
                }) {
                    Image(systemName: "plus")
            })
                .sheet(isPresented: $showingAddHabit) {
                    AddHabitView(habitList: self.habitList)
            }
        }
    }
    
    private func removeItems(at offsets: IndexSet) {
        habitList.habits.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
