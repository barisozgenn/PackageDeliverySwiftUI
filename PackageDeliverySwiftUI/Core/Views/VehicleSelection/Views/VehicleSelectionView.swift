//
//  VehicleSelection.swift
//  VehicleDeliverySwiftUI
//
//  Created by Baris OZGEN on 8.06.2023.
//

import SwiftUI

struct VehicleSelectionView: View {
    let selectedPackage : EPackageType
    let km: Double
    
    @State var vehicles: [EVehicleType] = EVehicleType.allCases//[.bicycle,.scooter,.car,.van]
    @State var selectionId: EVehicleType.ID? = EVehicleType.bicycle.id
    @State var buttonText = ""
    @Binding var selectedVehicle: EVehicleType?

    
    var body: some View {
        ScrollView {
            VehiclesSection(vehicles: vehicles, km: km, selectionId: $selectionId)
            paymentType
            confirmButton
        }
        .padding(.top)
        .background(.clear)
        .onChange(of: selectionId){ oldOne, newOne in
            buttonText = "\(String(format: "%.2f",vehicles.first(where: {$0.id == newOne!})!.pricePerKm * km))$"
        }
    }
    
}

extension VehicleSelectionView {
    private var confirmButton : some View {
        Button(action: {
            if selectionId != nil {
                selectedVehicle = vehicles.first(where: {$0.id == selectionId})
            }
        }) {
            HStack{
                Spacer()
                Text("Confirm \(buttonText)")
                    .foregroundStyle(.white)
                    .bold()
                Spacer()
            }
            .padding()
            .padding(.horizontal, 29)
            .background(.blue)
            .clipShape(.rect(cornerRadius: 14.0))
            .padding(.horizontal)
            .padding(.top,7)
        }
    }
    private var paymentType : some View {
        VStack(spacing: 10){
            HStack(spacing: 14){
                Image(systemName: "creditcard.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 24)
                    .padding()
                    .foregroundColor(.blue)
                
                
                Text("**** 1234".uppercased())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.primary)
                    .fontWeight(.bold)
                    .font(.headline)
                
                Image(systemName: "chevron.right")
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(.gray)
                
            }
        }
        .frame(height: 50, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(14)
        .padding(.horizontal)
        .onAppear{
            /*buttonText = "\(String(format: "%.2f",vehicles.first(where: {$0.id == selectionId!})!.pricePerKm * km))$"
            */
            vehicles = vehicles.filter{$0.maxPackageLimit.maxKg >= selectedPackage.maxKg}
        }
    }
}
#Preview {
    VehicleSelectionView(selectedPackage: .xs, km: 7.29, selectedVehicle: .constant(.bicycle))
}





