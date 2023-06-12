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
    
    @State var selectedItem: MKMapItem? = nil
    @Binding var selectedPickupItem: MKMapItem?
    @Binding var selectedDropOffItem: MKMapItem?

    @Binding var selectedStep : EDeliveryChoiceSteps
    
    @State private var colorMyPin: LinearGradient = LinearGradient(colors: [.red, .orange], startPoint: .top, endPoint: .center)
    
    func updateCameraPosition(focus centerCoordinate: CLLocationCoordinate2D, distance:Double,  heading: Double, pitch:Double){
        withAnimation(.spring()){
        cameraProsition = .camera(MapCamera(centerCoordinate: centerCoordinate, distance: distance, heading: heading, pitch: pitch))
        }
    }
    var body: some View {
        Map(position: $cameraProsition, interactionModes: .all, selection: $selectedItem){
            
            
           
            if selectedStep == .request {
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
            }
            
            if let route = vm.routePickupToDropOff {
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
            if selectedStep == .pickup {
                selectedPickupItem = selectedItem
            }
            if selectedStep == .dropoff {
                selectedDropOffItem = selectedItem
            }
            if selectedStep == .dropoff,
                let selectedPickupItem,
                let selectedDropOffItem {
                vm.getDirections(
                    from: selectedPickupItem,
                    to: selectedDropOffItem,
                    step: selectedStep)
            }
           
        }
        .onChange(of: vm.searchResultsForDrivers){
            updateCameraPosition(focus: .locU, distance: 1429, heading: 92, pitch: 70)
        }
        .onChange(of: selectedDropOffItem){
           
            updateCameraPosition(focus: selectedDropOffItem?.placemark.coordinate, distance: 3429, heading: 92, pitch: 70)
            
        }
        .onChange(of: selectedStep){
            withAnimation(.spring()){
                switch selectedStep {
                case .pickup:
                    updateCameraPosition(focus: .locU, distance: 992, heading: 70, pitch: 60)
                case .package:
                    updateCameraPosition(focus: .locU, distance: 2729, heading: 92, pitch: 70)
                case .dropoff:
                    updateCameraPosition(focus: .locU, distance: 992, heading: 70, pitch: 60)
                case .request:
                    updateCameraPosition(focus: .locU, distance: 3729, heading: 92, pitch: 70)
                }
            }
        }
        .onChange(of: selectedDropOffItem){
            if let newLoc = selectedDropOffItem?.placemark.coordinate {
                updateCameraPosition(focus: newLoc, distance: 992, heading: 70, pitch: 60)
            }
        }
    }
}

#Preview {
    NewMapView(vm: MapViewModel(),
               selectedPickupItem: .constant(nil),
               selectedDropOffItem:.constant(nil),
               selectedStep: .constant(.pickup))
}
