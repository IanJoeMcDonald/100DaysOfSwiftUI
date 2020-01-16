//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Masipack Eletronica on 06/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria",
                            "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    @State private var animationAmount = [0.0, 0.0, 0.0]
    @State private var opacity = [1.0, 1.0, 1.0]
    @State private var scaleAmount:[CGFloat] = [1.0, 1.0, 1.0]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top,
                           endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                            .rotation3DEffect(.degrees(self.animationAmount[number]), axis: (x: 0, y: 1, z: 0))
                            .opacity(self.opacity[number])
                            .scaleEffect(self.scaleAmount[number])
                    }
                }
                Text("Your score is \(score)")
                    .foregroundColor(.white)
                Spacer()
            }
        }.alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            scoreMessage = ""
            score += 1
            withAnimation {
                animationAmount[number] += 360
                for index in 0 ..< 3 {
                    if index != number {
                        opacity[index] = 0.25
                    }
                }
            }
        } else {
            scoreTitle = "Wrong"
            scoreMessage = "Wrong! That's the flag of \(countries[number])\n"
            score -= 1
            withAnimation {
                scaleAmount[correctAnswer] = 1.5
                animationAmount[correctAnswer] += 360
                for index in 0 ..< 3 {
                    if index != correctAnswer {
                        opacity[index] = 0.25
                        scaleAmount[index] = 0.25
                    }
                }
            }
        }
        scoreMessage += "Your score is \(score)"
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        withAnimation {
            for index in 0 ..< 3 {
                opacity[index] = 1.0
                scaleAmount[index] = 1.0
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
