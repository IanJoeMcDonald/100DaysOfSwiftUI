//
//  ContentView.swift
//  Animations
//
//  Created by Ian McDonald on 14/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingRed = false
    var body: some View {
        VStack{
            Button("Tap Me") {
                withAnimation {
                    self.isShowingRed.toggle()
                }
            }
            if isShowingRed {
                Rectangle()
                    .fill(Color.red)
                    .frame(width:200, height: 200)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
