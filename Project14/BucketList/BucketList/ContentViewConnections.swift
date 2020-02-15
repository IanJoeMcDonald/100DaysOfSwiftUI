//
//  ContentViewConnections.swift
//  BucketList
//
//  Created by Ian McDonald on 15/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import MapKit

class ContentViewConnections: ObservableObject {
    @Published var locations = [CodableMKPointAnnotation]()
    @Published var selectedPlace: MKPointAnnotation?
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var showingAlert = false
    @Published var showingAlertSecondButton = false
    @Published var showingEditScreen = false
}
