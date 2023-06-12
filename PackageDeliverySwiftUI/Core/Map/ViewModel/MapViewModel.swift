//
//  MapViewModel.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 9.06.2023.
//
import MapKit
import Observation
import SwiftUI
@Observable class MapViewModel/*:ObservedObject*/ {
    /*@Published*/ var routePickupToDropOff: MKRoute? = MKRoute()
    /*@Published*/ var routeDriverToPickup: MKRoute? = MKRoute()

    /*@Published*/ var routePolyline: MKPolyline? = MKPolyline()
    /*@Published*/ var lookAroundScene: MKLookAroundScene? = nil
    /*@Published*/ var searchResultsForDrivers: [MKMapItem] = []
    /*@Published*/ var searchResults: [MKMapItem] = []
    /*@Published*/ var myLocation: [MKMapItem] = []

    func getDirectionsPolyLine(selectedItem : MKMapItem) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: .loc3)) // Replace with your pickup location
        request.destination = selectedItem // Replace with destination coordinates
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first, error == nil {
                DispatchQueue.main.async { [weak self] in
                    self?.routePolyline = route.polyline
                }
            }
        }
    }
    func getDirections(from pickup: MKMapItem, to dropOff : MKMapItem, step selectedStep : EDeliveryChoiceSteps) {
        if selectedStep == .dropoff {
            routePickupToDropOff = nil
        }else {
            routeDriverToPickup = nil
        }
        //guard let pickupLocation = searchResultsForDrivers.first else {return} // for demo
        let request = MKDirections.Request()
        request.source = pickup // Replace with your pickup location
        request.destination = dropOff // Replace with destination coordinates
        request.transportType = .automobile
        
        Task.detached {
            let directions = MKDirections(request: request)
            do {
                let response = try await directions.calculate()
                DispatchQueue.main.async { [weak self] in
                    if selectedStep == .dropoff {
                        self?.routePickupToDropOff = response.routes.first
                    }else {
                        self?.routeDriverToPickup = response.routes.first
                    }
                }
            } catch {
                // Handle any errors that occur during the async operation
                print("Error: \(error)")
            }
        }
    }
    //getLookAroundScene to see 360 photos from the location you select. It is not available for all locations for now as far as I see
    func getLookAroundScene(selectedItem : MKMapItem) {
        lookAroundScene = nil
        Task.detached {
            let request = MKLookAroundSceneRequest(mapItem: selectedItem)
            do {
                let scene = try await request.scene
                DispatchQueue.main.async { [weak self] in
                    self?.lookAroundScene = scene
                }
            } catch {
                // Handle any errors that occur during the async operation
                print("Error: \(error)")
            }
        }
    }
   //searchDriverLocations is a demo functions that you can collect drivers data that near your location
    func searchDriverLocations() {
        let request = MKLocalSearch.Request ()
        request.naturalLanguageQuery = "coffee"
        request.resultTypes = .pointOfInterest
        request.region = MKCoordinateRegion(
            center: .locU,// it demo center coordinate you can replace it user's current location
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        Task.detached {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            DispatchQueue.main.async { [weak self] in
                self?.searchResultsForDrivers = response?.mapItems ?? []
            }
        }
    }
    //searchLocations is a demo functions that you can search locations to show on the map
    func searchLocations(for query: String, from location: CLLocationCoordinate2D) {
        let request = MKLocalSearch.Request ()
        request.naturalLanguageQuery = query
        request.resultTypes = .address // here we are looking for the address we typed
        request.region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007))
        Task.detached {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            DispatchQueue.main.async { [weak self] in
                self?.searchResults = response?.mapItems ?? []
            }
        }
    }
    //for demo replace it later
    func searchMyLocation() {
        let request = MKLocalSearch.Request ()
        request.naturalLanguageQuery = "coffee fellows"
        request.resultTypes = .pointOfInterest // here we are looking for the address we typed
        request.region = MKCoordinateRegion(
            center: .locU,
            span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        Task.detached {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.29) { [weak self] in
                if let mapItems = response?.mapItems{
                    self?.myLocation = [mapItems[0]]
                    CLLocationCoordinate2D.locU = mapItems[0].placemark.coordinate
                }
            }
        }
    }
}
