//
//  ContentView.swift
//  iExpense
//
//  Created by Ian McDonald on 20/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    if item.amount < 10 {
                        ExpenseView(item: item)
                            .foregroundColor(.green)
                    } else if item.amount < 100 {
                        ExpenseView(item: item)
                            .foregroundColor(.yellow)
                    } else {
                        ExpenseView(item: item)
                            .foregroundColor(.red)
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading: EditButton(),
                                trailing:
                Button(action : {
                    self.showingAddExpense = true
                }) {
                    Image(systemName: "plus")
            })
                .sheet(isPresented: $showingAddExpense) {
                    AddView(expenses: self.expenses)
            }
        }
    }
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ExpenseView : View {
    
    var item: ExpenseItem
    
    var body: some View {
        HStack {
            VStack {
                Text(item.name)
                    .font(.headline)
                Text(item.type)
            }
            Spacer()
            Text("$\(item.amount)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
