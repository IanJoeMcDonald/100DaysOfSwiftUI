//
//  MissionView.swift
//  Moonshot
//
//  Created by Ian McDonald on 21/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct MissionView: View {
    let mission: Mission
    let astronauts: [CrewMember]
    @State private var showingPopUp = false
    static var startingOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack() {
                    GeometryReader { geo in
                        HStack {
                            Spacer()
                            Image(self.mission.image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: geometry.size.width * 0.7)
                                .scaleEffect(1 - self.getHeight(geo))
                                .padding(.top)
                            Spacer()
                                .onAppear(perform: {
                                    MissionView.startingOffset = geo.frame(in: .global).maxY
                                })
                        }
                    }
                    
                    Text(self.mission.formatterLaunchDate)
                        .padding()
                    
                    Text(self.mission.description)
                        .padding()
                        .onTapGesture {
                            self.showingPopUp = true
                    }
                    
                    ForEach(self.astronauts, id: \.role) { crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut)) {
                            HStack {
                                Image(crewMember.astronaut.id)
                                .resizable()
                                    .frame(width: 83, height: 60)
                                .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                                
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    Text(crewMember.role)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer(minLength: 25)
                }
            }
        }
    }
    
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission
        
        var matches = [CrewMember]()
        
        for member in mission.crew {
            if let match = astronauts.first(where: { $0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Mission \(member)")
            }
        }
        
        self.astronauts = matches
    }
    
    func getHeight(_ geometry: GeometryProxy) -> CGFloat {
        var offset = MissionView.startingOffset - geometry.frame(in: .global).maxY
        
        
        if offset > 200 {
        //Ensure is not larger than maximum offset (200)
            offset = 200
        } else if offset > MissionView.startingOffset {
        //Scaling geometry.frame(in: .global).maxY became negative set max offset
            offset = 200
        } else if offset < 0 {
        //Do not scale up the image
            offset = 0
        }
        
        //The maximum reduction is 20%
        let amountToChange = 0.2 - ((200 - offset)*0.2/100)
        return amountToChange
    }
}

extension HorizontalAlignment {
    enum MidImageAndText: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[.leading]
        }
    }
    
    static let midImageAndText = HorizontalAlignment(MidImageAndText.self)
}

struct CrewMember {
    let role: String
    let astronaut: Astronaut
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("austronauts.json")
    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts)
    }
}
