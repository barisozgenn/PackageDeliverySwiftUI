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
    /*@Published*/ var lookAroundScene: MKLookAroundScene? = nil
    /*@Published*/ var searchResults: [MKMapItem] = []
    
    private var lookAroundSceneIn: MKLookAroundScene? = nil
    
    func getDirectionsPolyLine(selectedItem : MKMapItem) {
        let request = MKDirections.Request()
        request.source = selectedItem
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: .loc9)) // Replace with destination coordinates
        request.transportType = .automobile
        
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
        
        Task.detached {
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
    func getLookAroundScene(selectedItem : MKMapItem) {
        lookAroundScene = nil
        Task.detached {
            let request = MKLookAroundSceneRequest(mapItem: selectedItem)
            do {
                let scene = try await request.scene
                DispatchQueue.main.async {
                    self.lookAroundScene = scene
                    self.lookAroundSceneIn = scene
                }
            } catch {
                // Handle any errors that occur during the async operation
                print("Error: \(error)")
            }
        }
    }
   
    func search(for query: String) {
        let request = MKLocalSearch.Request ()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = MKCoordinateRegion(
            center: .loc1,
            span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
        }
    }
}
