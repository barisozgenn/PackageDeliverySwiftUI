//
//  NewMapView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 9.06.2023.
//

import SwiftUI
import _MapKit_SwiftUI

struct NewMapView: View {
    @Bindable var vm = MapViewModel()
    @State private var cameraProsition: MapCameraPosition = .camera(MapCamera(centerCoordinate: .locU, distance: 1429, heading: 92, pitch: 70))
    @State private var selectedItem: MKMapItem?
    @State private var locationSelectedSheet: Bool = false
    
    var body: some View {
        Map(position: $cameraProsition, interactionModes: .all, selection: $selectedItem){
            
            /*Marker("You are here", monogram: "Baris", coordinate:  .locU)
                .tint(.blue)
                .annotationTitles(.automatic)
                .tag("IAM")*/
           
            ForEach(vm.searchResultsForDrivers, id: \.self){ result in
                let driver = EVehicleType.allCases.shuffled().first!
                Annotation(driver.title, coordinate: result.placemark.coordinate) {
                    ZStack {
                        Circle()
                            .fill(driver.iconColor)
                            .shadow(color: .black, radius: 2)
                        Image(systemName: driver.image)
                            .padding (7)
                            .foregroundStyle(.white)
                    }
                    
                }
                .annotationTitles(.automatic)
            }
            if let route = vm.route {
                MapPolyline(route)
                    .stroke(LinearGradient.gradientWalk, style: .strokeWalk)
            }
            if let myLocation = vm.myLocation {
                Annotation("You are here", coordinate: myLocation.placemark.coordinate) {
                    ZStack {
                        Circle()
                            .fill(.blue)
                            .shadow(color: .black, radius: 2)
                        Text("Baris")
                            .padding (7)
                            .foregroundStyle(.white)
                    }
                    
                }
                .mapOverlayLevel(level: 2)
                .annotationTitles(.automatic)

            }
        }
        .mapControls{
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
            MapPitchButton()
        }
        .mapStyle(.standard(elevation: .automatic))
        .onAppear{
            vm.searchMyLocation()
            vm.searchDriverLocations()
        }
        .onChange(of: selectedItem){
            guard let selectedItem else {return}
            //vm.getDirections(selectedItem: selectedItem)
        }
        .onChange(of: vm.searchResults){
            guard let searchResult = vm.searchResults.first else {return}
        }
        .onChange(of: vm.searchResultsForDrivers){
            guard let searchResult = vm.searchResultsForDrivers.first else{return}
            withAnimation(.smooth){
                cameraProsition = .camera(MapCamera(centerCoordinate: .locU, distance: 2429, heading: 92, pitch: 70))
            }
        }
        .safeAreaInset(edge: .bottom) {
            if let selectedItem {
                LocationDetailView(selectedItem: selectedItem, vm: vm)
                    .frame(height: 300)
            }
        }
    }
}

#Preview {
    NewMapView()
}
