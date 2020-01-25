//
//  Order.swift
//  CupcakeCorner
//
//  Created by Ian McDonald on 25/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import Foundation

class Order: ObservableObject {
    @Published var item = OrderItem()
}
