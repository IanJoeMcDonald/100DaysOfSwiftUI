//
//  RollerView.swift
//  DiceRoller
//
//  Created by Masipack Eletronica on 05/03/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct RollerView: View {
    let colors: [Color] = [.blue, .green, .yellow, .pink, .purple, .orange]
    @EnvironmentObject var rolls: Rolls
    
    @State private var result = "0"
    @State private var numberOfSides = 6
    @State private var backgroundColor = Color.red
    static var timeBetweenResults = 0.05
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Result")
                Text(result)
                    .padding()
                    .background(backgroundColor)
                    .foregroundColor(.black)
                Spacer()
                Stepper("Number of Sides:    \(numberOfSides)", value: $numberOfSides, in: 6...50)
                    .padding()
                Button(action: {
                    RollerView.timeBetweenResults = 0.002
                    self.rollDice()
                }) {
                    Text("Roll the Dice")
                        .font(.headline)
                        .padding()
                    
                }
                .padding(.horizontal)
                .background(Color.blue)
                .foregroundColor(.white)
                .padding(.bottom)
            }
            .navigationBarTitle("DiceRoller", displayMode: .inline)
        }
    }
    
    func generateNumber(numberOfSides: Int) -> Int {
        return (1...numberOfSides).randomElement() ?? numberOfSides
    }
    
    func rollDice() {
        DispatchQueue.main.asyncAfter(deadline: .now() + RollerView.timeBetweenResults) {
            print(RollerView.timeBetweenResults)
            if(RollerView.timeBetweenResults >= 0.3) {
                let result = self.generateNumber(numberOfSides: self.numberOfSides)
                let roll = Roll()
                roll.numberOfSides = self.numberOfSides
                roll.result = result
                self.rolls.add(roll)
                self.result = String(result)
                self.backgroundColor = Color.red
            } else {
                let result = self.generateNumber(numberOfSides: self.numberOfSides)
                self.result = String(result)
                self.backgroundColor = self.colors[result % 6]
                RollerView.timeBetweenResults = RollerView.timeBetweenResults * sqrt(2)
                self.rollDice()
            }
        }
    }
}

struct RollerView_Previews: PreviewProvider {
    static var previews: some View {
        RollerView()
    }
}
