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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
