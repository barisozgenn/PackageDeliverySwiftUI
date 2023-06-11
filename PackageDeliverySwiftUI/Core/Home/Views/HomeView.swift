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
    
    @State var selectedStep : EDeliveryChoiceSteps = .pickup
    @State var selectedPackage : EPackageType? = nil
    @State var selectedVehicle : EVehicleType? = nil
    @State var stepsDone: [EDeliveryChoiceSteps] = []
    
    
    @State private var isPickupLocationSelected: Bool = false
    @State private var isPackageSelected: Bool = false
    @State private var isVehicleSelected: Bool = false
    
    
    var body: some View {
        ZStack{
            NewMapView(vm: mapViewModel, selectedItem: $selectedItem, selectedStep: $selectedStep)
                .sheet(isPresented: $isPickupLocationSelected){
                    if let selectedItem {
                        LocationDetailView(selectedItem: selectedItem, vm: mapViewModel, stepsDone: $stepsDone)
                            .presentationDetents([
                                .height(329),
                                .fraction(0.62)])
                    }
                }
                .sheet(isPresented: $isPackageSelected){
                    PackageSelectionView(selectedPackage: $selectedPackage)
                        .presentationDetents([
                            .height(429),
                            .fraction(0.54)])
                    /*VehicleSelectionView(selectedPackage: .l, km: 14.29)
                        .presentationDetents([
                            .height(529),
                            .fraction(0.62)])*/
                
                   
                }
            DeliveryChoiceStepsView(selectedStep: $selectedStep, stepsDone: $stepsDone)
            
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
        .onChange(of: selectedItem){oldV, newV in
            if !stepsDone.contains(.pickup) {
                isPickupLocationSelected = true
            }
        }
        .onChange(of: selectedStep){oldV, newV in
            Task.detached {
               
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.29) {
                    withAnimation(.spring()){
                        switch selectedStep {
                        case .pickup:
                            if selectedItem != nil && !stepsDone.contains(.pickup) {
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
                            if stepsDone.contains(.package) && !stepsDone.contains(.dropoff) {
                                
                            }
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
            }
        }
    }
}

#Preview {
    HomeView()
}
