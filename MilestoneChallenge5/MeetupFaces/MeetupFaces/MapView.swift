//
//  MapView.swift
//  BucketList
//
//  Created by Ian McDonald on 13/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    var map = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        map.delegate = context.coordinator
        return map
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func showLocation(_ location: CLLocationCoordinate2D) {
        map.setCenter(location, animated: false)
    }
    
    func addAnnotation(_ annotation: MKPointAnnotation) {
        map.addAnnotation(annotation)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // this is our unique indetifier for reuse
            let identifier = "Placemark"
            
            // attempt to fina a cell we can recycle
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                // we didn't fine one; make a new one
                annotationView = MKPinAnnotationView(annotation: annotation,
                                                     reuseIdentifier: identifier)
                
                // allow this to show pop up information
                annotationView?.canShowCallout = true
                
            } else {
                // we have a view to reuse, so git it the new annotation
                annotationView?.annotation = annotation
            }
            
            // whether it's a new vier or a recycled one, send it back
            return annotationView
        }
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(centerCoordinate: .constant(MKPointAnnotation.example.coordinate))
    }
}

extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics."
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return annotation
    }
}
