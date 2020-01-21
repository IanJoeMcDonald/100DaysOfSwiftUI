//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Ian McDonald on 20/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String
    let amount : Int
}
