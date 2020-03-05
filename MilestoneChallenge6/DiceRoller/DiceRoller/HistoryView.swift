//
//  HistoryView.swift
//  DiceRoller
//
//  Created by Masipack Eletronica on 05/03/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var rolls: Rolls
    
    var body: some View {
        NavigationView {
            List (rolls.list) { roll in
                HStack {
                    Image(systemName: "\(roll.result).circle")
                    
                    VStack(alignment: .leading) {
                        Text("Result: \(roll.result)")
                            .font(.headline)
                        Text("Dice: \(roll.numberOfSides) sided")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationBarTitle("History", displayMode: .inline)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
