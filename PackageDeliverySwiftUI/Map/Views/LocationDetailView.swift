//
//  LocationDetailView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 7.06.2023.
//

import SwiftUI
import MapKit
import Combine
class LocationDetailViewModel: ObservableObject {
    @Published var lookAroundScene: MKLookAroundScene?
    @Published var route: MKRoute?
     @Published var selectedItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)))

    
    func getLookAroundScene() {
        lookAroundScene = nil
        Task {
            let request = MKLookAroundSceneRequest(mapItem: selectedItem)
            do {
                let scene = try await request.scene
                DispatchQueue.main.async {
                    self.lookAroundScene = scene
                }
            } catch {
                // Handle any errors that occur during the async operation
                print("Error: \(error)")
            }
        }
    }
    
    func getDirections() {
        route = nil
        let request = MKDirections.Request()
        request.source = selectedItem
        request.destination =  MKMapItem(placemark: MKPlacemark(coordinate: .loc12))
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

struct LocationDetailView: View {
    let selectedItem: MKMapItem
    @ObservedObject var vm = LocationDetailViewModel()
    
    var travelTime: String? {
       /* guard let vm.route else { return nil }
        let formatter = DateComponentsFormatter ()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string (from: vm.route.expectedTravelTime)*/
        return "3m"
    }
    init(){
        self.selectedItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 42.547918, longitude: -70.870583)))
    }
    
    var body: some View {
        LookAroundPreview(initialScene: vm.lookAroundScene)
            .overlay(alignment: .bottomLeading){
                VStack(alignment: .leading){
                    Text("Hey Baris!")
                        .font(.title)
                    Text("Confirm the pickup location for your package.")
                        .font(.title3)
                    HStack{
                        Text(selectedItem.name ?? "not selected")
                        if let travelTime {
                            Text(travelTime)
                        }
                    }
                }
                .foregroundStyle(.white)
                .fontDesign(.rounded)
                .fontWidth(.expanded)
                .padding()
                .padding(.bottom, 58)
            }
            .onAppear{
                vm.getLookAroundScene()
                vm.getDirections()
            }
        //.background(.thinMaterial)
            .presentationDetents([.fraction(0.29)])
            .ignoresSafeArea()
    }
}

#Preview {
    LocationDetailView()
}
