//
//  ContentView.swift
//  Drawing
//
//  Created by Ian McDonald on 22/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State private var lineWidth: CGFloat = 5
    
    var body: some View {
        Arrow()
            .stroke(Color.red, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
            .frame(width:300, height: 400)
            .onTapGesture {
                withAnimation {
                    self.lineWidth += 5
                }
        }
    }
}

struct Arrow: Shape {
    func path(in rect: CGRect) -> Path {
        let rectWidth = rect.width / CGFloat(4)
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX + rectWidth, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - rectWidth, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - rectWidth, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX + rectWidth, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX + rectWidth, y: rect.maxY))
        
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
