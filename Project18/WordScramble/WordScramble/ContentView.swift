//
//  ContentView.swift
//  WordScramble
//
//  Created by Ian McDonald on 12/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    static var lastOffset:CGFloat = 0
    static var firstOffset = true
    
    var score: Int {
        var score = 0
        for word in usedWords {
            if word.count < 6 {
                score += word.count
            } else {
                score += (word.count * 2)
            }
        }
        return score
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { fullView in
                VStack {
                    TextField("Enter your word", text: self.$newWord, onCommit: self.addNewWord)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    List(self.usedWords, id: \.self) { word in
                        GeometryReader { geo in
                            HStack() {
                                Image(systemName: "\(word.count).circle")
                                Text(word)
                                Spacer()
                            }
                            .offset(x: self.calculateXOffset(localGeometry: geo,
                                                             globalGeometry: fullView),
                                    y: 0)
                        }
                    }
                    Text("Your current score is \(self.score)")
                        .font(.title)
                }
            }
            .navigationBarTitle(rootWord)
            .navigationBarItems(leading: Button(action: startGame) {
                Text("New Word")
            })
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func calculateXOffset(localGeometry geo: GeometryProxy,
                          globalGeometry fullView: GeometryProxy) -> CGFloat {
        if geo.frame(in: .global).midY < (fullView.size.height * 2 / 3) {
            return 0
        } else {
            if ContentView.firstOffset {
                ContentView.firstOffset = false
                ContentView.lastOffset = geo.frame(in: .global).midY / fullView.size.height * fullView.size.width / 3
            }
            
            let currentOffset = geo.frame(in: .global).midY / fullView.size.height *
                fullView.size.width / 3
            return max(currentOffset - ContentView.lastOffset, 0)
        }
    }
    
    func addNewWord() {
        // lowercase and trim the word, to make sure we don't duplication words with case differences
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // exit if the remaing string is empty
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not recoginzed", message: "You can't just make them up you know")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            return
        }
        
        guard isNotStart(word: answer) else {
            wordError(title: "Word is start of suggestion", message: "The word cannot be the start of the suggestion")
            return
        }
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return (misspelledRange.location == NSNotFound && word.count > 3)
    }
    
    func isNotStart(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if letter == tempWord.first {
                tempWord.remove(at: tempWord.startIndex)
            } else {
                return true
            }
        }
        
        return false
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func startGame() {
        usedWords.removeAll(keepingCapacity: true)
        newWord = ""
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")
                
                // 4. Pick on randow word, or use "silkworm"as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"
                
                // If we are here everything has worked, so we can exit
                return
            }
            // If we are *here* then there was a problem - trigger a crash and report the error
            fatalError("Could not load start.txt from bundle")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
