//
//  AddView.swift
//  MeetupFaces
//
//  Created by Masipack Eletronica on 23/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI
import MapKit

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var users: Users
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var showingImagePicker = false
    @State private var viewControl = 0
    @State private var name = ""
    @State private var info = ""
    @State private var image: Image?
    @State private var tempImage: UIImage?
    let uuid: String?
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        VStack(spacing: 30) {
            VStack {
                Picker(selection: self.$viewControl, label: Text("View Control")) {
                    Text("Photo").tag(0)
                    Text("Map").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                if self.viewControl == 0 {
                    ZStack {
                        Rectangle()
                            .fill(Color.secondary)
                        
                        if image != nil {
                            image?
                                .resizable()
                                .scaledToFit()
                        } else {
                            Text("Tap to select a picture")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                    }
                    .onTapGesture {
                        if self.uuid == nil {
                            self.showingImagePicker = true
                        }
                    }
                } else {
                    addMap()
                }
            }
            VStack {
                Text("Name")
                TextField("Name", text: $name)
                    .overlay(RoundedRectangle(cornerRadius: 3)
                        .stroke(Color.gray, lineWidth: 1))
            }
            VStack{
                Text("Additional Information")
                TextField("Additional Information", text: $info)
                    .overlay(RoundedRectangle(cornerRadius: 3)
                        .stroke(Color.gray, lineWidth: 1))
            }
            Button(action: self.addNewUser) {
                HStack {
                    Spacer()
                    Text("Save")
                    Spacer()
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: imageAdded) {
            ImagePicker(image: self.$tempImage)
        }
        .onAppear(perform: startUp)
        
    }
    
    func imageAdded() {
        if let tempImage = tempImage {
            image = Image(uiImage: tempImage)
        }
    }
    
    func addNewUser() {
        if let uuid = uuid {
            if let user = users.list.first(where: { $0.id == uuid }) {
                user.name = name
                user.additional = info
            }
        } else {
            let uuid = UUID().uuidString
            let location = locationFetcher.lastKnownLocation ?? CLLocationCoordinate2D()
            let user = User(id: uuid, name: name, additional: info, location: location)
            LoadSave().saveImage(tempImage, forID: uuid)
            users.list.append(user)
        }
        LoadSave().saveUsers(users)
        presentationMode.wrappedValue.dismiss()
    }
    
    func addMap() -> MapView {
        let annotation = MKPointAnnotation()
        if let uuid = uuid {
            if let user = users.list.first(where: { $0.id == uuid }) {
                annotation.coordinate = user.location
                annotation.title = user.name
                annotation.subtitle = user.additional
            }
        }
        let mapView = MapView(centerCoordinate: $centerCoordinate)
        mapView.showLocation(annotation.coordinate)
        mapView.addAnnotation(annotation)
        
        return mapView
    }
    
    func startUp() {
        loadValues()
        locationFetcher.start()
    }
    
    func loadValues() {
        if let uuid = uuid {
            if let user = users.list.first(where: { $0.id == uuid }){
                name = user.name
                info = user.additional
                tempImage = LoadSave().loadUIImage(uuid: user.id)
                if let tempImage = tempImage {
                    image = Image(uiImage: tempImage)
                }
            }
        }
    }
    
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(users: Users(), uuid: "")
    }
}
