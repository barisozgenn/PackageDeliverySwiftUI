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
    @State private var selectedItem: MKMapItem?
    @State private var locationSelectedSheet: Bool = false

    var body: some View {
        Map(position: $cameraProsition, interactionModes: .all, selection: $selectedItem){
            Marker("You are here", monogram: "Baris", coordinate:  .loc1)
                .tint(.blue)
                .annotationTitles(.automatic)
                .tag("IAM")
            ForEach(vm.searchResults, id: \.self){ result in
                Marker(item: result)
                    .tag(UUID())
                    .annotationTitles(.hidden)
            }
            if let route = vm.route {
                MapPolyline(route)
                    .stroke(LinearGradient.gradientWalk, style: .strokeWalk)
            }
        }
        .mapStyle(.standard(elevation: .automatic))
        .onAppear{
            vm.searchLocations(for: "parking")
        }
        .onChange(of: selectedItem){
            guard let selectedItem else {return}
            vm.getDirections(selectedItem: selectedItem)
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
