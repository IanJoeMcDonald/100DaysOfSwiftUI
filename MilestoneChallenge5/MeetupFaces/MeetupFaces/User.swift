//
//  User.swift
//  MeetupFaces
//
//  Created by Masipack Eletronica on 22/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import MapKit

class User: Codable, Identifiable {
    var id: String
    var name: String
    var additional: String
    var longitude: Double
    var latitude: Double
    
    init(id: String, name: String = "", additional: String = "",
         location: CLLocationCoordinate2D = CLLocationCoordinate2D()) {
        self.id = id
        self.name = name
        self.additional = additional
        self.longitude = location.longitude
        self.latitude = location.latitude
    }
    
    var location: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(latitude, longitude)
        }
    }
}
