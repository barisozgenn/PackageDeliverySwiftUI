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


struct MapView: View {
    @State private var locationSelectedSheet: Bool = false
    @State private var searchResults: [MKMapItem] = []
    @State private var position: MapCameraPosition = .automatic
    @State private var focusedRegion: MKCoordinateRegion?
    @Binding var selectedItem: MKMapItem?
    @State private var route: MKRoute?
    
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
    
    var body: some View {
        Map(position: $position, selection: $selectedItem) {
           /* if let route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 5)
            }*/
            MapPolyline(coordinates: [.loc12, .loc3,])
                .stroke(.yellow, lineWidth: 10)
            
            MapPolyline(coordinates: [.loc1, .loc2, .loc3])
                .stroke(gradientWalk, style: strokeWalk)
            
            MapPolyline(coordinates: [.loc3, .loc4, .loc5, .loc6, .loc7, .loc8, .loc9])
                .stroke(.blue, lineWidth: 10)
            
            MapPolyline(coordinates: [.loc9, .loc10, .loc11])
                .stroke(gradientWalk, style: strokeWalk)
            
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
                        selectedItem = MKMapItem(placemark: MKPlacemark(coordinate: .loc12))
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
            withAnimation(.smooth){
                position = .automatic
                   // .camera(MapCamera(centerCoordinate: .loc3, distance: 392, heading: 229, pitch: 58))
             
            }
        }
       
        .onMapCameraChange { context in
            focusedRegion = context.region
        }
        .sheet(isPresented: $locationSelectedSheet){
            LocationDetailView(selectedItem: $selectedItem, route: $route)
        }
        
    }
}

#Preview {
    MapView(selectedItem: .constant(MKMapItem(placemark: MKPlacemark(coordinate: .loc1))))
}
