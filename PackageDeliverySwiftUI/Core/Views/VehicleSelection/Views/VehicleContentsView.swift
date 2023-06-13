//
//  VehicleContentsView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 9.06.2023.
//

import SwiftUI

struct VehicleContentsView: View {
    var vehicles: [EVehicleType]
    let km: Double
    @Binding var selectionId: EVehicleType.ID?
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: hSpacing) {
                ForEach(vehicles) { vehicle in
                    VehicleDetailView(vehicle: vehicle, km: km)
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(.horizontal, hMargin)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $selectionId)
        .scrollIndicators(.never)
       
    }
    
    var hMargin: CGFloat {
        20.0
    }
    
    var hSpacing: CGFloat {
        10.0
    }
}

struct VehicleDetailView: View {
    var vehicle: EVehicleType
    let km: Double
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    init(vehicle: EVehicleType, km: Double) {
        self.vehicle = vehicle
        self.km = km
    }
    var body: some View {
        
        ZStack{
            colorStack
            VStack(alignment: .leading){
                HStack{
                    Text("Deliver by \(vehicle.title)")
                        .font(.title)
                        .bold()
                    Spacer()
                    Image(systemName: vehicle.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                }
                .foregroundStyle(vehicle.iconColor)
                HStack(alignment: .center){
                    VStack{
                        Image(systemName: vehicle.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64)
                    }
                    .foregroundStyle(vehicle.iconColor.opacity(0.7))
                    Spacer()
                    HStack{
                        VStack(alignment: .trailing){
                            
                            Text("estimated time")
                                .font(.headline)
                                .bold()
                                .foregroundStyle(vehicle.iconColor.opacity(0.7))
                            Text("\(Int(km*100 / vehicle.speedKmHour))m")
                                .font(.title)
                                .bold()
                                .foregroundStyle(Color(.systemGray))
                        }
                        Divider()
                            .frame(height: 29)
                            .padding(3)
                        VStack(alignment: .trailing){
                            Text("fee")
                                .font(.headline)
                                .bold()
                                .foregroundStyle(vehicle.iconColor.opacity(0.7))
                            Text("\(String(format: "%.2f", Double(km * vehicle.pricePerKm)))$")
                                .font(.title)
                                .bold()
                                .foregroundStyle(Color(.systemGray))
                        }
                    }
                    
                }
            }
            .padding(.all)
            .padding(.trailing,40)
            .offset(y: -20)
        }
        .aspectRatio(heroRatio, contentMode: .fit)
        .containerRelativeFrame(
            [.horizontal], count: columns, spacing: hSpacing
        )
        .clipShape(.rect(cornerRadius: 29.0))
        .scrollTransition(axis: .horizontal) { content, phase in
            content
                .scaleEffect(
                    x: phase.isIdentity ? 1.0 : 0.58,
                    y: phase.isIdentity ? 1.0 : 0.58)
        }
    }
    
    private var columns: Int {
        sizeClass == .compact ? 1 : regularCount
    }
    @ViewBuilder
    private var colorStack: some View {
        let offsetValue = stackPadding
        ZStack {
            Color(.systemGray2)
                .offset(x: offsetValue, y: offsetValue)
            Color(.systemGray4)
            Color(.systemGray6)
                .offset(x: -offsetValue, y: -offsetValue)
            
        }
        .padding(stackPadding)
        .background()
    }
    var stackPadding: CGFloat {
        20.0
    }
    
    var heroRatio: CGFloat {
        16.0 / 9.0
    }
    
    var regularCount: Int {
        2
    }
    
    var hSpacing: CGFloat {
        10.0
    }
}

#Preview {
    VehicleContentsView(vehicles: EVehicleType.allCases, km: 14, selectionId: .constant(nil))
}
