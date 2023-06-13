//
//  VehiclesSection.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 9.06.2023.
//

import SwiftUI

struct VehiclesSection: View {
    var vehicles: [EVehicleType]
    let km: Double
    @Binding var selectionId: EVehicleType.ID?
    
    var body: some View {
        VehicleSection(edge: .top) {
            VehicleContentsView(vehicles: vehicles, km: km, selectionId: $selectionId)
        } label: {
            VehicleContentHeaderView(vehicles: vehicles, selectionId: $selectionId)
        }
    }
}

struct VehicleSection<Content: View, Label: View>: View {
    var edge: Edge? = nil
    @ViewBuilder var content: Content
    @ViewBuilder var label: Label
    
    var body: some View {
        VStack(alignment: .leading) {
            label
                .font(.title2.bold())
            content
        }
        .padding(.top, halfSpacing)
        .padding(.bottom, sectionSpacing)
        .overlay(alignment: .bottom) {
            if edge != .bottom {
                Divider().padding(.horizontal, hMargin)
            }
        }
    }
    
    var halfSpacing: CGFloat {
        sectionSpacing / 2.0
    }
    
    var sectionSpacing: CGFloat {
        20.0
    }
    
    var hMargin: CGFloat {
        20.0
    }
}


#Preview {
    VehiclesSection(vehicles: EVehicleType.allCases, km: 14, selectionId: .constant(nil))
}
