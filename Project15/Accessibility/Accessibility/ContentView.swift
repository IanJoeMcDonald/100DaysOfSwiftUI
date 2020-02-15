//
//  ContentView.swift
//  Accessibility
//
//  Created by Ian McDonald on 15/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var estimate = 25.0
    @State private var rating = 3
    
    var body: some View {
        VStack {
            
            Slider(value: $estimate, in: 0...50)
                .padding()
                .accessibility(value: Text("\(Int(estimate))"))
            Stepper("Rating out service: \(rating)/5", value: $rating, in: 1...5)
                .accessibility(value: Text("\(rating) out of 5"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
