//
//  MapView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 7.06.2023.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let loc1 = CLLocationCoordinate2D(latitude: 42.360506, longitude: -71.057499)//my loc
    static let loc2 = CLLocationCoordinate2D(latitude: 42.360106, longitude: -71.057409)
    static let loc3 = CLLocationCoordinate2D(latitude: 42.360106, longitude: -71.057009)//pickup loc
    
    static let loc4 = CLLocationCoordinate2D(latitude: 42.361506, longitude: -71.057559)
    static let loc5 = CLLocationCoordinate2D(latitude: 42.362671, longitude: -71.055634)
    static let loc6 = CLLocationCoordinate2D(latitude: 42.364375, longitude: -71.053822)
    static let loc8 = CLLocationCoordinate2D(latitude: 42.365395, longitude: -71.052946)
    static let loc7 = CLLocationCoordinate2D(latitude: 42.364883, longitude: -71.053314)
    static let loc9 = CLLocationCoordinate2D(latitude: 42.365356, longitude: -71.052981)
    
    static let loc10 = CLLocationCoordinate2D(latitude: 42.365581, longitude: -71.053354)
    static let loc11 = CLLocationCoordinate2D(latitude:  42.365533, longitude: -71.053412)
    
    static let loc12 = CLLocationCoordinate2D(latitude:  42.358658, longitude: -71.056692)//driver
    
}

class MapViewModel: ObservableObject {
    var selectedItem: MKMapItem?
    @Published  var route: MKRoute?
    @Published  var routePolyline: MKPolyline?
    
    init(selectedItem: MKMapItem?) {
        self.selectedItem = selectedItem
    }
    func getDirections2() {
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
struct MapMainView: View {
    let arr: [CLLocationCoordinate2D] = [.loc1, .loc2, .loc3, .loc4, .loc5, .loc6, .loc7, .loc8, .loc9, .loc10, .loc11, .loc12]
    @State var cameraCoordinate: CLLocationCoordinate2D = .loc1

    var body: some View {
        TimelineView(.periodic(from: .now, by: 4.5)) { timeline in
            
            let cameraCoordinate: CLLocationCoordinate2D =  arr[2]
            
            VStack{
                MapView(cameraCoordinate: cameraCoordinate, selectedItem: MKMapItem(placemark: MKPlacemark(coordinate: cameraCoordinate)))

                //LocationDetailView()
            }
           
        }
    }
}

struct MapView: View {
    @State private var locationSelectedSheet: Bool = false
    @State private var searchResults: [MKMapItem] = []
    @State private var position: MapCameraPosition = .automatic
    @State private var focusedRegion: MKCoordinateRegion?
    @ObservedObject private var vm : MapViewModel
    @State private var riderLocation: CLLocationCoordinate2D = .loc12
    
    let gradientWalk = LinearGradient(
        colors: [.orange, .green, .blue],
        startPoint: .leading, endPoint: .trailing)
    let strokeWalk = StrokeStyle(
        lineWidth: 5,
        lineCap: .round, lineJoin: .bevel, dash: [10, 10])
    
    let gradientDrive = LinearGradient(
        colors: [.blue, .green],
        startPoint: .leading, endPoint: .trailing)
    
    let cameraCoordinate: CLLocationCoordinate2D
    
    init(cameraCoordinate: CLLocationCoordinate2D, selectedItem: MKMapItem){
        self.cameraCoordinate = cameraCoordinate
        vm = MapViewModel(selectedItem: selectedItem)
        vm.getDirections()
        vm.getDirections2()
    }
    
    var body: some View {
        Map(position: $position, selection: $vm.selectedItem) {
         
             // Unfortunatelly it gives many errors in beta version so I defined all locs manually
            if let routePolyline = vm.routePolyline {
                MapPolyline(routePolyline)
                    .stroke(.blue, lineWidth: 5)
            }else{
            }
            if let route = vm.route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 5)
            }
             
            /*MapPolyline(coordinates: [.loc12, .loc3,])
                .stroke(.yellow, lineWidth: 10)
            
            MapPolyline(coordinates: [.loc1, .loc2, .loc3])
                .stroke(gradientWalk, style: strokeWalk)
            
            MapPolyline(coordinates: [.loc3, .loc4, .loc5, .loc6, .loc7, .loc8, .loc9])
                .stroke(.blue, lineWidth: 10)
            
            MapPolyline(coordinates: [.loc9, .loc10, .loc11])
                .stroke(gradientWalk, style: strokeWalk)
            */
            Marker("You are here", monogram: "Baris", coordinate: .loc1)
                .tint(.blue)
                .annotationTitles(.automatic)
            
            Marker("pickup", monogram: "Pickup", coordinate: .loc3)
                .tint(.black)
                .annotationTitles(.hidden)
            Marker("dropoff", monogram: "Drop Off", coordinate: .loc11)
                .tint(.black)
            Annotation("Rider", coordinate: riderLocation) {
                ZStack {
                    Circle()
                        .fill(.green)
                    Circle()
                        .stroke(.yellow, lineWidth: 1)
                    Image(systemName: "figure.outdoor.cycle")
                        .padding (7)
                        .foregroundStyle(.white)
                }
                .onTapGesture {
                    
                    withAnimation(.smooth){
                        position =
                            .camera(MapCamera(centerCoordinate: .loc12, distance: 729, heading: 170, pitch: 58))
                        vm.selectedItem = MKMapItem(placemark: MKPlacemark(coordinate: .loc12))
                    }
                }
            }
            .annotationTitles(.hidden)
        }
        .mapStyle(.standard(elevation: .realistic))
        .mapControls{
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
            MapPitchButton()
        }
        .onAppear{
            
            withAnimation(.smooth(duration: 1, extraBounce: 2)){
                position =  .camera(MapCamera(centerCoordinate: cameraCoordinate, distance: 392, heading: 229, pitch: 58))
                
            }
            
            
        }
        .onChange(of: cameraCoordinate.latitude) {
                withAnimation(.smooth(duration: 1, extraBounce: 2)){
                    position =  .camera(MapCamera(centerCoordinate: cameraCoordinate, distance: 392, heading: 229, pitch: 58))
                }
        }
        .onMapCameraChange { context in
            focusedRegion = context.region
        }
        .sheet(isPresented: $locationSelectedSheet){
            LocationDetailView()
        }
    }
}

#Preview {
    MapMainView()
}

