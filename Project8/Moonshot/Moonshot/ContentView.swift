//
//  ContentView.swift
//  Moonshot
//
//  Created by Ian McDonald on 21/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showingDates = true
    
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width:44, height: 44)
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        Text(self.showingDates ? mission.formatterLaunchDate : self.crewNames(mission: mission.id))
                    }
                }
            }
            .navigationBarTitle("Moonshot")
            .navigationBarItems(trailing:
                HStack {
                    Spacer()
                    Button(showingDates ? "Crew Names" : "Date") {
                        self.showingDates.toggle()
                    }
            })
        }
    }
    
    func crewNames(mission: Int) -> String {
        guard let missionInfo = missions.first(where: { $0.id == mission}) else { return "" }
        var first = true
        var returnString = ""
        for crew in missionInfo.crew {
            if(!first) {
                returnString += ", "
            }
            first = false
            let astronaut = astronauts.first(where: { $0.id == crew.name })
            returnString += astronaut?.name ?? ""
        }
        
        return returnString
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
