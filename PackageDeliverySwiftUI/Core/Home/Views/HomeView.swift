//
//  HomeView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 6.06.2023.
//

import SwiftUI
import MapKit


struct HomeView: View {
    @Bindable private var mapViewModel = MapViewModel()
    
    @State private var selectedPickupItem: MKMapItem? = nil
    @State private var selectedDropOffItem: MKMapItem? = nil
    
    @State var selectedStep : EDeliveryChoiceSteps = .pickup
    @State var selectedPackage : EPackageType? = nil
    @State var selectedVehicle : EVehicleType? = nil
    @State var stepsDone: [EDeliveryChoiceSteps] = []
    
    @State private var isPickupLocationSelected: Bool = false
    @State private var isPackageSelected: Bool = false
    @State private var isVehicleSelected: Bool = false
    
    @State private var searchText: String = ""
    
    var body: some View {
        ZStack{
            NewMapView(vm: mapViewModel,
                       selectedPickupItem: $selectedPickupItem,
                       selectedDropOffItem: $selectedDropOffItem,
                       selectedStep: $selectedStep)
            .sheet(isPresented: $isPickupLocationSelected){
                LocationDetailView(
                    selectedPickupItem: $selectedPickupItem,
                    selectedDropOffItem: $selectedDropOffItem,
                    vm: mapViewModel,
                    stepsDone: $stepsDone)
                .presentationDetents([
                    .height(329),
                    .fraction(0.62)])
            }
            .sheet(isPresented: $isPackageSelected){
                PackageSelectionView(selectedPackage: $selectedPackage)
                    .presentationDetents([
                        .height(429),
                        .fraction(0.54)])
            }
            .sheet(isPresented: $isVehicleSelected){
                VehicleSelectionView(selectedPackage: .l, km: 14.29, selectedVehicle: $selectedVehicle)
                    .presentationDetents([
                        .height(529),
                        .fraction(0.62)])
            }
            
            DeliveryChoiceStepsView(selectedStep: $selectedStep, stepsDone: $stepsDone, searchText: $searchText)
            
        }
        .onChange(of: stepsDone){
            stepsDone.forEach { step in
                switch step {
                case .pickup:
                    isPickupLocationSelected = false
                    
                case .dropoff:
                    isPickupLocationSelected = false
                    
                default:
                    return
                }
            }
        }
        .onChange(of: selectedPickupItem){oldV, newV in
            if !stepsDone.contains(.pickup) {
                isPickupLocationSelected = true
            }
        }
        .onChange(of: selectedDropOffItem){oldV, newV in
            if !stepsDone.contains(.dropoff) && oldV != newV {
                isPickupLocationSelected = true
            }
        }
        .onChange(of: selectedStep){oldV, newV in
            Task.detached {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.29) {
                    withAnimation(.spring()){
                        switch selectedStep {
                        case .pickup:
                            if selectedPickupItem != nil && !stepsDone.contains(.pickup) {
                                isPickupLocationSelected = true
                            }
                        case .package:
                            if stepsDone.contains(.pickup) && !stepsDone.contains(.package) {
                                if selectedPackage == nil {
                                    isPackageSelected = true
                                }else {
                                    isVehicleSelected = true
                                }                    }
                        case .dropoff:
                           
                            return
                        case .request:
                            return
                        }
                    }
                }
            }
        }
        .onChange(of: selectedPackage){oldV, newV in
            if oldV != newV && newV != nil {
                isPackageSelected = false
                if !stepsDone.contains(.package){ stepsDone.append(.package)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
