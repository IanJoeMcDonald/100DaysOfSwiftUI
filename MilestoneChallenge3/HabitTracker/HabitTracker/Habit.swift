//
//  Habit.swift
//  HabitTracker
//
//  Created by Ian McDonald on 25/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import Foundation

struct Habit: Codable, Identifiable {
    let id = UUID()
    let title: String
    let description: String
    var count: Int = 0
}
