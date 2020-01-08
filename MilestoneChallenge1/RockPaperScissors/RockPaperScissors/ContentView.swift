//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Ian McDonald on 08/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    private let choices = ["✊","🖐","✌️"]
    @State private var questionNumber = 0
    @State private var computerChoice = Int.random(in: 0 ..< 2)
    @State private var shouldWin = Bool.random()
    @State private var showGameOver = false
    @State private var playerScore = 0
    @State private var gameOverMessage = ""
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.red, .black]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                Text("Your score is: \(playerScore)")
                    .font(.title)
                    .foregroundColor(.white)
                Text(choices[computerChoice])
                    .font(Font.custom("SF", size: 100))
                HStack {
                    Text("Player should:")
                    .foregroundColor(.yellow)
                    Text("\(shouldWin ? "Win": "Lose")")
                        .foregroundColor(shouldWin ? .green : .white)
                }.font(.largeTitle)
                
                HStack(spacing: 50) {
                    ForEach(choices, id: \.self) { id in
                        Button(action: {
                            self.answerTapped(id)
                        }) {
                            Text(id).font(Font.custom("SF", size: 75))
                        }
                    }
                }
                Spacer()
            }.alert(isPresented: $showGameOver) {
                Alert(title: Text("Game Over"), message: Text(gameOverMessage), dismissButton: .default(Text("Restart Game")) {
                    self.restartGame()
                })
            }
        }
    }
    
    func askQuestion() {
        let oldChoice = computerChoice
        let oldWin = shouldWin
        computerChoice = Int.random(in: 0 ..< choices.count)
        shouldWin = Bool.random()
        if (oldChoice == computerChoice && oldWin == shouldWin){
            askQuestion()
        }
    }
    
    func restartGame() {
        playerScore = 0
        questionNumber = 0
        askQuestion()
    }
    
    func answerTapped(_ answer: String) {
        let currentChoice = choices[computerChoice]
        if shouldWin {
            if (currentChoice == "✊" && answer == "🖐") {
                playerScore += 2
            } else if (currentChoice == "🖐" && answer == "✌️") {
                playerScore += 2
            } else if (currentChoice == "✌️" && answer == "✊") {
                playerScore += 2
            } else {
                playerScore -= 1
            }
        } else {
            if (currentChoice == "✊" && answer == "✌️") {
                playerScore += 2
            } else if (currentChoice == "🖐" && answer == "✊") {
                playerScore += 2
            } else if (currentChoice == "✌️" && answer == "🖐") {
                playerScore += 2
            } else {
                playerScore -= 1
            }
        }
        questionNumber += 1
        
        if questionNumber >= 10 {
            showGameOver = true
            gameOverMessage = "Your final score is \(playerScore)"
        } else {
            askQuestion()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
