//
//  MapView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 7.06.2023.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let loc1 = CLLocationCoordinate2D(latitude: 42.360506, longitude: -71.057499)
    static let loc2 = CLLocationCoordinate2D(latitude: 42.360106, longitude: -71.057409)
    static let loc3 = CLLocationCoordinate2D(latitude: 42.360106, longitude: -71.057009)
    static let loc4 = CLLocationCoordinate2D(latitude: 42.349436, longitude: -71.077881)
    
}

extension MKCoordinateRegion {
    static let dumboView = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.702846, longitude:  -73.989099),
        span: MKCoordinateSpan( latitudeDelta: 0.5, longitudeDelta: 0.5))
}

struct MapView: View {
    @State private var locationSelectedSheet: Bool = false
    @State private var searchResults: [MKMapItem] = []
    @State private var position: MapCameraPosition = .automatic
    @State private var focusedRegion: MKCoordinateRegion?
    @Binding var selectedItem: MKMapItem?
    @State private var route: MKRoute?
    
    let gradient = LinearGradient(
        colors: [.red, .green, .blue],
        startPoint: .leading, endPoint: .trailing)
    let stroke = StrokeStyle(
        lineWidth: 5,
        lineCap: .round, lineJoin: .round, dash: [10, 10])
    
    var body: some View {
        Map(position: $position, selection: $selectedItem) {
           /* if let route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 5)
            }*/
            MapPolyline(coordinates: [.loc1, .loc2, .loc3])
                .stroke(gradient, style: stroke)
            
            
             Marker("baris", monogram: "Baris", coordinate: .loc1)
             .tint(.blue)
            Marker("baris", monogram: "Pickup", coordinate: .loc3)
            .tint(.black)
             .tag("corousel")
             .annotationTitles(.hidden)
            /*Marker(item: MKMapItem(placemark: MKPlacemark(coordinate: .loc2)))
                .tag("pof")*/
            
            /*Annotation("Parking", coordinate: .loc3) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.background)
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.secondary, lineWidth: 5)
                    Image(systemName: "car")
                        .padding (5)
                }
                .onTapGesture {
                    withAnimation(.smooth){
                        position =
                            .camera(MapCamera(centerCoordinate: .loc1, distance: 980, heading: 229, pitch: 29))
                        //.region(MKCoordinateRegion(center: .parking3, latitudinalMeters: 3, longitudinalMeters: 10))
                        selectedItem = MKMapItem(placemark: MKPlacemark(coordinate: .loc3))
                    }
                }
            }*/
            
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
                position =
                    .camera(MapCamera(centerCoordinate: .loc1, distance: 392, heading: 229, pitch: 58))
                //.region(MKCoordinateRegion(center: .parking3, latitudinalMeters: 3, longitudinalMeters: 10))
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
