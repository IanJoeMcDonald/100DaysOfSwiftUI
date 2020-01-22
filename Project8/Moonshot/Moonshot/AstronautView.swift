//
//  AstronautView.swift
//  Moonshot
//
//  Created by Ian McDonald on 21/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    var missionsFlown : String {
        var missionsString = ""
        var first = true
        for mission in missions {
            for crewMember in mission.crew {
                if astronaut.id == crewMember.name {
                    if (!first) {
                        missionsString += ", "
                    }
                    first = false
                    missionsString += "Apollo \(mission.id)"
                }
            }
        }
        
        return missionsString
    }
    
    var body: some View {
        GeometryReader { gemoetry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: gemoetry.size.width)
                    
                    Text(self.missionsFlown)
                        .padding()
                    
                    Text(self.astronaut.description)
                        .padding()
                        .layoutPriority(1)
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        AstronautView(astronaut: astronauts[0])
    }
}
