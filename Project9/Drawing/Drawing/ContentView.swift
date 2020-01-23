//
//  ContentView.swift
//  Drawing
//
//  Created by Ian McDonald on 22/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State private var amount: CGFloat = 0.0
    
    var body: some View {
        VStack {
            Image("PaulHudson")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .saturation(Double(amount))
                .blur(radius: (1 - amount) * 20)
            
            Slider(value: $amount)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
