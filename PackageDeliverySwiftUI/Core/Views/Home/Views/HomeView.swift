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
    @State private var selectedDriverItem: MKMapItem? = nil
    
    @State var selectedStep : EDeliveryChoiceSteps = .pickup
    @State var selectedPackage : EPackageType? = nil
    @State var selectedVehicle : EVehicleType? = nil
    @State var stepsDone: [EDeliveryChoiceSteps] = []
    
    @State private var isPickupLocationSelected: Bool = false
    @State private var isDropOffLocationSelected: Bool = false
    @State private var isPackageSelected: Bool = false
    @State private var isVehicleSelected: Bool = false
    
    @State private var searchText: String = ""
    
    @State var isDeliveryStepsStarted: Bool = false
    @State var deliveryPercent: Double = 0
    
    var body: some View {
        ZStack{
            // show map view included map functions
            newMapView
            // track delivery if the steps are done
            deliveryStepsView
            // show delivery choice steps
            deliveryChoiceStepsView
        }
        .onChange(of: stepsDone){
            stepsDone.forEach { step in
                switch step {
                case .pickup:
                    isPickupLocationSelected = false
                    
                case .dropoff:
                    isDropOffLocationSelected = false
                    
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
            if !stepsDone.contains(.dropoff) && stepsDone.contains(.package) {
                isDropOffLocationSelected = true
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
                                }
                            }
                        case .dropoff:
                            if !stepsDone.contains(.dropoff) &&
                                oldV != newV &&
                                stepsDone.contains(.package) &&
                                selectedDropOffItem != nil {
                                isDropOffLocationSelected = true
                            }
                        case .request:
                            if stepsDone.contains(.dropoff) &&
                                !stepsDone.contains(.request){
                                isVehicleSelected = true
                            }
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
        .onChange(of: isVehicleSelected){oldV, newV in
            if selectedVehicle != nil {
                
                isVehicleSelected = false
                
                if !stepsDone.contains(.request){ stepsDone.append(.request)
                }
                Task.detached {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.92) {
                        isDeliveryStepsStarted = true
                    }
                }
            }
        }
        .onChange(of: selectedDriverItem){
            Task.detached {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.29) {
                    deliveryPercent = 14.29
                }
            }
        }
    }
    
    private var deliveryChoiceStepsView: some View {
        DeliveryChoiceStepsView(selectedStep: $selectedStep, stepsDone: $stepsDone, searchText: $searchText, isDeliveryStepsStarted: $isDeliveryStepsStarted)
    }
    private var deliveryStepsView: some View {
        DeliveryStepsView(
            selectedVehicle: $selectedVehicle,
            selectedPickupItem: $selectedPickupItem,
            selectedDropOffItem: $selectedDropOffItem,
            selectedDriverItem: $selectedDriverItem,
            vm: mapViewModel,
            isDeliveryStepsStarted: $isDeliveryStepsStarted,
            deliveryPercent: $deliveryPercent)
    }
    
    private var newMapView: some View {
        NewMapView(vm: mapViewModel,
                   selectedPickupItem: $selectedPickupItem,
                   selectedDropOffItem: $selectedDropOffItem,
                   selectedDriverItem: $selectedDriverItem,
                   selectedStep: $selectedStep,
                   searchText: $searchText,
                   selectedVehicle: $selectedVehicle)
        .sheet(isPresented: $isPickupLocationSelected){
            LocationDetailView(
                selectedPickupItem: $selectedPickupItem,
                selectedDropOffItem: .constant(nil),
                vm: mapViewModel,
                stepsDone: $stepsDone)
            .presentationDetents([
                .height(329),
                .fraction(0.62)])
        }
        .sheet(isPresented: $isDropOffLocationSelected){
            LocationDetailView(
                selectedPickupItem: $selectedPickupItem,
                selectedDropOffItem: $selectedDropOffItem,
                vm: mapViewModel,
                stepsDone: $stepsDone)
            .presentationDetents([
                .height(607),
                .fraction(0.77)])
        }
        .sheet(isPresented: $isPackageSelected){
            PackageSelectionView(selectedPackage: $selectedPackage)
                .presentationDetents([
                    .height(429),
                    .fraction(0.54)])
        }
        .sheet(isPresented: $isVehicleSelected){
            VehicleSelectionView(selectedPackage: selectedPackage ?? .s, km: 14.29, selectedVehicle: $selectedVehicle)
                .presentationDetents([
                    .height(529),
                    .fraction(0.62)])
        }
        
    }
}

#Preview {
    HomeView()
}
