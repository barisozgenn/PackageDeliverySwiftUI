//
//  HomeView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 6.06.2023.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let janesCarousel = CLLocationCoordinate2D(latitude: 40.704722466849994, longitude: -73.99248505951677)
    static let dumbo = CLLocationCoordinate2D(latitude: 40.70342684235291, longitude: -73.98954414006195)
    static let manhattanBridge = CLLocationCoordinate2D(latitude: 40.70796059396952,  longitude: -73.99079110770766)
    
}

struct HomeView: View {
    
    @State private var searchResults: [MKMapItem] = []
    @State private var position: MapCameraPosition = .automatic
    
    var body: some View {
        ZStack{
            Map(position: $position) {
                Marker("baris", systemImage: "car.fill", coordinate: .dumbo)
                Marker("baris", monogram: "Baris", coordinate: .janesCarousel)
                    .tint(.blue)
                
                Annotation("Parking", coordinate: .manhattanBridge) {
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
                                .camera(MapCamera(centerCoordinate: .manhattanBridge, distance: 9, heading: 29, pitch: 29))
                                //.region(MKCoordinateRegion(center: .parking3, latitudinalMeters: 3, longitudinalMeters: 10))
                            
                        }
                    }
                }
                .annotationTitles(.hidden)
            }
            .mapStyle(.standard(elevation: .realistic))
            
        }
    }
}

#Preview {
    HomeView()
}
