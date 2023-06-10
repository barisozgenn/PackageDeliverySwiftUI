//
//  NewMapView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 9.06.2023.
//

import SwiftUI
import _MapKit_SwiftUI

struct NewMapView: View {
    @Bindable var vm : MapViewModel
    @State private var cameraProsition: MapCameraPosition = .camera(MapCamera(centerCoordinate: .locU, distance: 3729, heading: 92, pitch: 70))
    @Binding var selectedItem: MKMapItem?
    @State private var locationSelectedSheet: Bool = false
    
    @State private var colorMyPin: LinearGradient = LinearGradient(colors: [.red, .orange], startPoint: .top, endPoint: .center)
    
    func updateCameraPosition(focus centerCoordinate: CLLocationCoordinate2D, distance:Double,  heading: Double, pitch:Double){
        withAnimation(.spring()){
        cameraProsition = .camera(MapCamera(centerCoordinate: centerCoordinate, distance: distance, heading: heading, pitch: pitch))
        }
    }
    var body: some View {
        Map(position: $cameraProsition, interactionModes: .all, selection: $selectedItem){
            
            /*Marker("You are here", monogram: "Baris", coordinate:  .locU)
                .tint(.blue)
                .annotationTitles(.automatic)
                .tag("IAM")*/
           
            /*ForEach(vm.searchResultsForDrivers, id: \.self){ result in
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
            }*/
            if let route = vm.route {
                MapPolyline(route)
                    .stroke(LinearGradient.gradientWalk, style: .strokeWalk)
            }
           
                ForEach(vm.myLocation, id: \.self){ result in
                    Annotation("You are here", coordinate: result.placemark.coordinate) {
                        Image("profil_photo_baris")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48)
                            .clipShape(Circle())
                            .padding(4)
                            .background(colorMyPin)
                            .clipShape(Circle())
                            .offset(y: -16)
                            .overlay(alignment: .bottom) {
                                Image(systemName: "triangle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(colorMyPin)
                                    .frame(width: 24)
                                    .scaleEffect(y: -1)
                                    
                            }
                            .onAppear{
                                updateCameraPosition(focus: .locU, distance: 992, heading: 70, pitch: 60)
                            }
                    }
                    .annotationTitles(.automatic)
                }
                

            
        }
        .mapControls{
            //MapUserLocationButton()
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
            updateCameraPosition(focus: .locU, distance: 1429, heading: 92, pitch: 70)
            
        }
    }
}

#Preview {
    NewMapView(vm: MapViewModel(), selectedItem: .constant(nil))
}
