//
//  MapView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 7.06.2023.
//

import SwiftUI
import MapKit


struct MapMainView: View {
    /*@ObservedObject*/ @Bindable var vm: MapViewModel
    var cameraCoordinate: CLLocationCoordinate2D
    @State private var selectedItem: MKMapItem? = MKMapItem(placemark: MKPlacemark(coordinate: .loc1))
    @State private var locationSelectedSheet: Bool = false
    @State private var searchResults: [MKMapItem] = []
    @State private var position: MapCameraPosition = .automatic
    @State private var focusedRegion: MKCoordinateRegion?
    @State private var riderLocation: CLLocationCoordinate2D = .loc12
    
    
    
    var body: some View {
        Map(position: $position, selection: $selectedItem) {
         
            if let route = vm.route {
                MapPolyline(route)
                  //  .stroke(.gradientWalk, style: .strokeWalk)
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
                        selectedItem = MKMapItem(placemark: MKPlacemark(coordinate: .loc12))
                    }
                }
            }
            .annotationTitles(.hidden)
        }
        //.mapStyle(.standard(elevation: .realistic))
        .mapControls{
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
            MapPitchButton()
        }
        .onAppear{
            if let selectedItem {
                //vm.getDirections(selectedItem: selectedItem)
                vm.getDirectionsPolyLine(selectedItem: selectedItem)
            }
          
            withAnimation(.smooth(duration: 1, extraBounce: 2)){
                position =  .camera(MapCamera(centerCoordinate: cameraCoordinate, distance: 392, heading: 229, pitch: 58))
                
            }
            
            
        }
        .onChange(of: cameraCoordinate.latitude) {
                withAnimation(.smooth(duration: 1, extraBounce: 2)){
                    position =  .camera(MapCamera(centerCoordinate: cameraCoordinate, distance: 392, heading: 229, pitch: 58))
                }
        }
        .onChange(of: selectedItem){
            if let selectedItem = selectedItem {
                //vm.getDirections(selectedItem: selectedItem)
                vm.getDirectionsPolyLine(selectedItem: selectedItem)

            }
        }
        .onMapCameraChange { context in
            focusedRegion = context.region
        }
        
    }
}

#Preview {
    MapMainView(vm: MapViewModel(), cameraCoordinate: .loc3)
}
