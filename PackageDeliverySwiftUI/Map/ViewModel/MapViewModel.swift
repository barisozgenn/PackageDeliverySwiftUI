//
//  MapViewModel.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 9.06.2023.
//
import MapKit
import Observation
import SwiftUI
@Observable class MapViewModel {
    /*@Published*/ var route: MKRoute? = MKRoute()
    /*@Published*/ var routePolyline: MKPolyline? = MKPolyline()
    
   
    func getDirectionsPolyLine(selectedItem : MKMapItem) {
        let request = MKDirections.Request()
        request.source = selectedItem
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: .loc10)) // Replace with destination coordinates
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first, error == nil {
                DispatchQueue.main.async {
                    self.routePolyline = route.polyline
                }
            }
        }
    }
    func getDirections(selectedItem : MKMapItem) {
        route = nil
        let request = MKDirections.Request()
        request.source = selectedItem
        request.destination =  MKMapItem(placemark: MKPlacemark(coordinate: .loc9))
        request.transportType = .automobile
        
        Task {
            let directions = MKDirections(request: request)
            do {
                let response = try await directions.calculate()
                DispatchQueue.main.async {
                    self.route = response.routes.first
                }
            } catch {
                // Handle any errors that occur during the async operation
                print("Error: \(error)")
            }
        }
    }
}
