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
    
    @State var vehicles: [EVehicleType] = [.bicycle,.scooter,.car,.van]
    @State var selectionId: EVehicleType.ID? = EVehicleType.bicycle.id
    @State var buttonText = ""
    
    init(selectedPackage : EPackageType, km: Double) {
        self.selectedPackage = selectedPackage
        self.km = km
    }
    var body: some View {
        ScrollView {
            VehiclesSection(vehicles: vehicles, km: km, selectionId: $selectionId)
            paymentType
            confirmButton
        }
        .padding(.top)
        .background(.clear)
    }
    private var confirmButton : some View {
        Button(action: {}) {
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
        .onChange(of: selectionId){ oldOne, newOne in
            buttonText = "\(String(format: "%.2f",vehicles.first(where: {$0.id == newOne!})!.pricePerKm * km))$"
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
            buttonText = "\(String(format: "%.2f",vehicles.first(where: {$0.id == selectionId!})!.pricePerKm * km))$"
            
            vehicles = vehicles.filter{$0.maxPackageLimit.maxKg <= selectedPackage.maxKg}
        }
    }
    
}

#Preview {
    VehicleSelectionView(selectedPackage: .s, km: 14.29)
}


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

struct VehiclePaddle: View {
    var edge: HorizontalEdge
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Label(labelText, systemImage: labelIcon)
        }
        .buttonStyle(.paddle)
        .font(nil)
    }
    
    var labelText: String {
        switch edge {
        case .leading:
            return "Backwards"
        case .trailing:
            return "Forwards"
        }
    }
    
    var labelIcon: String {
        switch edge {
        case .leading:
            return "chevron.backward"
        case .trailing:
            return "chevron.forward"
        }
    }
}

private struct PaddleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .imageScale(.large)
            .labelStyle(.iconOnly)
    }
}

extension ButtonStyle where Self == PaddleButtonStyle {
    static var paddle: Self { .init() }
}
