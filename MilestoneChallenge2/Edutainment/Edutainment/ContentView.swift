//
//  ContentView.swift
//  Edutainment
//
//  Created by Ian McDonald on 16/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showingSettings = true
    @State private var showingResultAlert = false
    
    @State private var multiplicationUpTo = 2
    @State private var questionOptionsIndex = 0
    
    @State private var questionText = ""
    @State private var answerText = ""
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var currentAnswer = 0
    @State private var score = 0
    @State private var questionNumber = 0
    @State private var selectedQuestions = [String:Int]()
    @State private var answerCorrect = false
    
    private let questionsOptions = ["5", "10", "20", "All"]
    
    private var allQuestions : [String:Int] {
        var questions = [String:Int]()
        for i in 1...12 {
            for j in 1...multiplicationUpTo {
                questions["\(i) * \(j)"] = i * j
            }
        }
        print("All Questions Count: \(questions.count)")
        return questions
    }
    
    private var numberOfQuestions : Int {
        return Int(questionsOptions[questionOptionsIndex]) ?? 12 * multiplicationUpTo
    }
    
    private var firstQuestion : Bool {
        return questionNumber == 0
    }

    var body: some View {
        Group {
            if showingSettings {
                Form {
                    Section (header: Text("Set maximum multiplication table value"))
                    {
                        Stepper("\(multiplicationUpTo)", value: $multiplicationUpTo, in: 2 ... 12)
                    }
                    Section (header: Text("Select the number of questions to answer")) {
                        Picker("Number of Questions", selection: $questionOptionsIndex) {
                            ForEach((0..<questionsOptions.count)) { value in
                                Text(self.questionsOptions[value])
                            }
                            
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    Button("Start Game") {
                        self.newGame()
                        self.showingSettings.toggle()
                    }
                }
            } else {
                VStack {
                    VStack(spacing: 20) {
                        VStack {
                            Text("Qustion \(questionNumber) / \(numberOfQuestions)")
                                .font(.caption)
                            Text(questionText)
                                .font(.largeTitle)
                        }
                        
                        VStack {
                            Text("Answer")
                                .font(.caption)
                            TextField("Answer", text: $answerText)
                                .keyboardType(.numberPad)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray)
                            )
                            
                            Button("Submit") {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                                to: nil, from: nil, for: nil)
                                self.verifyAnswer()
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            
                        }.alert(isPresented: $showingResultAlert) {
                            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                            self.askQuestion()
                            })
                        }
                    }
                }
            }
        }
    }
    
    func newGame() {
        questionNumber = 0
        score = 0
        selectQuestions()
        askQuestion()
    }
    
    func selectQuestions() {
        var tempAllQuestions = allQuestions
        var questions = [String:Int]()
        
        for _ in 1 ... numberOfQuestions {
            guard let question = tempAllQuestions.randomElement() else { return }
            tempAllQuestions.removeValue(forKey: question.key)
            questions[question.key] = question.value
        }
        selectedQuestions = questions
        
    }
    
    func verifyAnswer() {
        if let answerNumber = Int(answerText) {
            if currentAnswer == answerNumber {
                score += 2
                answerCorrect = true
                alertTitle = "Correct"
                alertMessage = "Your score is: \(score)"
            } else {
                score -= 1
                alertTitle = "Incorrect"
                alertMessage = "That is not the correct answer. Try again"
            }
        } else {
            alertTitle = "Invalid Answer"
            alertMessage = "The answer may only contain numbers"
        }
        
        if questionNumber >= numberOfQuestions {
            alertTitle = "Game Over"
            alertMessage = "Your final score is: \(score)"
        }
        showingResultAlert = true
    }
    
    func askQuestion() {
        if questionNumber >= numberOfQuestions {
            showingSettings.toggle()
        } else if answerCorrect || firstQuestion {
            questionNumber += 1
            guard let currentQuestion = selectedQuestions.randomElement() else { return }
            selectedQuestions.removeValue(forKey: currentQuestion.key)
            
            currentAnswer = currentQuestion.value
            questionText = currentQuestion.key
            answerCorrect = false
        }
        answerText = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
