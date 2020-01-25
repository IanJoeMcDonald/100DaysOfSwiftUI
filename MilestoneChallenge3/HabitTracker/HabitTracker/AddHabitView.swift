//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by Ian McDonald on 25/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct AddHabitView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var habitList: Habits
    @State private var title = ""
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
            }
            .navigationBarTitle("Add new habit")
            .navigationBarItems(trailing: Button("Save") {
                let habit = Habit(title: self.title, description: self.description)
                self.habitList.habits.append(habit)
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct AddHabitVIew_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView(habitList: Habits())
    }
}
