//
//  VehicleContentHeaderView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 9.06.2023.
//

import SwiftUI

struct VehicleContentHeaderView: View {
    var vehicles: [EVehicleType]
    @Binding var selectionId: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2.0) {
            Text("Vehicle Selection")
                .foregroundStyle(.primary)
                .font(.title2)
                .bold()
            Text("Please select the vehicle type for your intended delivery.")
                .foregroundStyle(.secondary)
                .font(.headline)
            Spacer().frame(maxWidth: .infinity)
        }
        .padding(.horizontal, hMargin)
    }
    
    private func scrollToNextID() {
        guard let id = selectionId, id != vehicles.last?.id,
              let index = vehicles.firstIndex(where: { $0.id == id })
        else { return }
        
        withAnimation {
            selectionId = vehicles[index + 1].id
        }
    }
    
    private func scrollToPreviousID() {
        guard let id = selectionId, id != vehicles.first?.id,
              let index = vehicles.firstIndex(where: { $0.id == id })
        else { return }
        
        withAnimation {
            selectionId = vehicles[index - 1].id
        }
    }
    
    var hMargin: CGFloat {
        20.0
    }
}


#Preview {
    VehicleContentHeaderView(vehicles: EVehicleType.allCases, selectionId: .constant(nil))
}
