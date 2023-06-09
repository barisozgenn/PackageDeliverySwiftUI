//
//  MapScenarioDriverSearch.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 9.06.2023.
//

import SwiftUI
import MapKit

struct MapScenarioDriverSearch: View {
    let drivers: [CLLocationCoordinate2D] = [.loc1, .loc2, .loc3, .loc4, .loc5, .loc6, .loc7, .loc8, .loc9, .loc10, .loc11, .loc12]
    @State var cameraCoordinate: CLLocationCoordinate2D = .loc1
    var selectedItem: MKMapItem? =  MKMapItem(placemark: MKPlacemark(coordinate: .loc1))
    var body: some View {
        TimelineView(.periodic(from: .now, by: 4.5)) { timeline in
            
            let cameraCoordinate: CLLocationCoordinate2D =  drivers[2]
            
            VStack{
                MapMainView(vm: MapViewModel(), cameraCoordinate: cameraCoordinate)
                //LocationDetailView()
            }
           
        }
    }
}

#Preview {
    MapScenarioDriverSearch()
}
