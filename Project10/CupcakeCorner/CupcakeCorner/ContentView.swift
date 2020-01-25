//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Ian McDonald on 25/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var order = Order()
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Select your cake type", selection: $order.item.type) {
                    ForEach(0..<OrderItem.types.count, id: \.self) {
                        Text(OrderItem.types[$0])
                    }
                }
                
                Stepper(value: $order.item.quantity, in: 3...20) {
                    Text("Number of cakes: \(order.item.quantity)")
                }
                
                Section {
                    Toggle(isOn: $order.item.specialRequestEnabled.animation()) {
                        Text("Any special requests?")
                    }
                    
                    if order.item.specialRequestEnabled {
                        Toggle(isOn: $order.item.extraFrosting) {
                            Text("Add extra frosting")
                        }
                        
                        Toggle(isOn: $order.item.addSprinkles) {
                            Text("Add extra sprinkles")
                        }
                    }
                }
                Section {
                    NavigationLink(destination: AddressView(order: order)) {
                        Text("Delivery details")
                    }
                }
            }
            .navigationBarTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
