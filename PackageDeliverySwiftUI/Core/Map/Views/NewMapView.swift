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
    @State private var cameraProsition: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $cameraProsition, interactionModes: .all){
            Marker("You are here", monogram: "Baris", coordinate: .loc1)
                .tint(.blue)
                .annotationTitles(.automatic)
            ForEach(vm.searchResults, id: \.self){ result in
            
                Marker(item: result)
                
            }
        }
        
        .mapStyle(.standard(elevation: .automatic))
        .onAppear{
            vm.search(for: "street")
        }
    }
}

#Preview {
    NewMapView()
}
