//
//  DetailView.swift
//  HabitTracker
//
//  Created by Ian McDonald on 25/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var habitList: Habits
    let index: Int
    var body: some View {
        Form {
            Text("Title: \(habitList.habits[index].title)")
                .font(.largeTitle)
                .padding()
            Text("Description: \(habitList.habits[index].description)")
                .font(.body)
                .padding()
            Stepper("Completion Count:  \(habitList.habits[index].count)", value: $habitList.habits[index].count, in: 0...Int.max)
            Spacer()
        }
        .navigationBarTitle(Text(habitList.habits[index].title), displayMode: .inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(habitList: Habits(), index: 0)
    }
}
