//
//  HomeView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 6.06.2023.
//

import SwiftUI
import MapKit


struct HomeView: View {
    
    @State private var selectedItem: MKMapItem?
    @Bindable private var mapViewModel = MapViewModel()
    @State private var isPickupLocationSelected: Bool = false

    var body: some View {
        ZStack{
            NewMapView(vm: mapViewModel, selectedItem: $selectedItem)
                .sheet(isPresented: $isPickupLocationSelected){
                    /*PackageSelectionView()
                        .presentationDetents([
                            .height(429),
                            .fraction(0.54)])*/
                    /*VehicleSelectionView(selectedPackage: .l, km: 14.29)
                        .presentationDetents([
                            .height(529),
                            .fraction(0.62)])*/
                
                    if let selectedItem {
                        LocationDetailView(selectedItem: selectedItem, vm: mapViewModel)
                            .presentationDetents([
                                .height(329),
                                .fraction(0.62)])
                    }
                }
            
        }
        .onChange(of: selectedItem){oldV, newV in
            if oldV != newV {
                isPickupLocationSelected.toggle()
            }
        }
    }
}

#Preview {
    HomeView()
}
