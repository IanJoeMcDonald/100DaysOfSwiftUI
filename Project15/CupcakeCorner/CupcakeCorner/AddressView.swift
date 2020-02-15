//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Ian McDonald on 25/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.item.name)
                TextField("Street Address", text: $order.item.streetAddress)
                TextField("City", text: $order.item.city)
                TextField("Zip", text: $order.item.zip)
            }
            Section {
                NavigationLink(destination: CheckoutView(order: order)) {
                    Text("Check out")
                }
                .disabled(order.item.hasValidAddress == false)
            }
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
