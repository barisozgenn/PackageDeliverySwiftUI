//
//  DeliveryStepsView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 13.06.2023.
//

import SwiftUI
import MapKit

struct DeliveryStepsView: View {
    @Binding var selectedVehicle : EVehicleType?
    @Binding var selectedPickupItem: MKMapItem?
    @Binding var selectedDropOffItem: MKMapItem?
    @Binding var selectedDriverItem: MKMapItem?
    @Bindable var vm : MapViewModel
    @Binding var isDeliveryStepsStarted: Bool

    @State var deliveryPercent: Double = 0
    @State private var colorMyPin: LinearGradient = LinearGradient(colors: [.red, .orange], startPoint: .top, endPoint: .center)
    
    @State private var deliveryStepsViewY: Double = 192

    var travelTimePickupToDropOff: String? {
        guard let route = vm.routePickupToDropOff else { return "0m" }
        let formatter = DateComponentsFormatter ()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string (from: route.expectedTravelTime)
    }
    
    var travelTimeDriverToPickup: String? {
        guard let route = vm.routeDriverToPickup else { return "0m" }
        let formatter = DateComponentsFormatter ()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string (from: route.expectedTravelTime)
    }
    
    var body: some View {
        VStack{
            if isDeliveryStepsStarted {
                Spacer()
                ZStack {
                    HStack{
                        RoundedRectangle(cornerSize: CGSize(width: 3.5, height: 3.5))
                            .fill(LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing))
                            .frame(width: 92,height: 7)
                            .padding(.leading, 29)
                        RoundedRectangle(cornerSize: CGSize(width: 3.5, height: 3.5))
                            .fill(.orange)
                            .frame(height: 7)
                            .padding(.leading, 26)
                            .padding(.trailing, 54)
                    }
                    HStack{
                        Circle()
                            .fill(.red)
                            .frame(width: 24)
                        
                        Spacer().frame(width: 92)
                        Circle()
                            .fill(.orange)
                            .frame(width: 24)
                            .padding(10)
                            .overlay(alignment: .top) {
                                pickupView
                                    .offset(y: -40)
                            }
                            .overlay(alignment: .bottom) {
                                if !(vm.routeDriverToPickup?.expectedTravelTime.isEqual(to: 0) ?? false) {
                                    Text(deliveryPercent > 36 ? "" : travelTimeDriverToPickup ?? "0")
                                        .font(.headline)
                                        .foregroundStyle(.orange)
                                        .offset(y: 14)
                                }
                                
                            }
                        Spacer()
                        Circle()
                            .fill(.orange)
                            .frame(width: 24)
                            .padding(24)
                            .overlay(alignment: .top) {
                                dropOffView
                                    .offset(y: -40)
                            }
                            .overlay(alignment: .bottom) {
                                if !(vm.routePickupToDropOff?.expectedTravelTime.isEqual(to: 0) ?? false) {
                                    Text(deliveryPercent == 100 ? "" :travelTimePickupToDropOff ?? "0")
                                        .font(.headline)
                                        .foregroundStyle(.orange)
                                }
                            }
                    }
                    HStack{
                        Spacer()
                            .frame(width: deliveryPercent * 3.5 )
                        driverView
                            .frame(width: 24)
                        Spacer(minLength: 20)
                    }
                }
                .shadow(color: .black.opacity(0.7), radius: 1, x: 0, y: 1)
                .padding()
                .onChange(of: selectedDriverItem){oldD, newD in
                    if let selectedPickupItem,
                       let newD {
                        vm.getDirections(from: newD, to: selectedPickupItem, step: .request)
                    }
                }
                .onChange(of: selectedDropOffItem){oldD, newD in
                    if let selectedPickupItem,
                       let newD {
                        vm.getDirections(from: selectedPickupItem, to: newD, step: .dropoff)
                    }
                }
                //for demo, it can be removed
                .onAppear{
                    if let selectedPickupItem,
                       let newD = selectedDropOffItem {
                        vm.getDirections(from: selectedPickupItem, to: newD, step: .dropoff)
                    }
                    if let selectedPickupItem,
                       let newD = selectedDriverItem{
                        vm.getDirections(from: newD, to: selectedPickupItem, step: .request)
                    }
                    withAnimation(.smooth.delay(1.29)){
                        deliveryStepsViewY = 0
                    }
                }
                .offset(y: deliveryStepsViewY)
            }
        }
    }
    private var driverView: some View {
        ZStack {
            Circle()
                .fill(selectedVehicle?.iconColor ?? .black)
                .shadow(color: .black, radius: 2)
            Image(systemName: selectedVehicle?.image ?? "car")
                .padding (7)
                .foregroundStyle(.white)
                .symbolEffect(
                    .pulse,
                    isActive: selectedDriverItem == nil ? true : false
                )
        }
        .overlay(alignment: .top) {
            if selectedDriverItem == nil || deliveryPercent == 0 {
                Image(systemName:  "antenna.radiowaves.left.and.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32)
                            .symbolEffect(
                                .variableColor.iterative.reversing
                            )
                            .foregroundStyle(selectedVehicle?.iconColor ?? .black)
                            .offset(y: -29)
            } else if deliveryPercent > 36 {
                Image(systemName: "shippingbox.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolEffect(
                        .pulse
                    )
                    .background(.white)
                    .foregroundColor(.orange)
                    .clipShape(Circle())
                    .frame(width: 24)
                    .offset(y: -29)
                    .shadow(color: .clear, radius: 0)
            }
            
        }
    }
    private var pickupView: some View {
        Image("profil_photo_baris")
            .resizable()
            .scaledToFit()
            .frame(width: 48)
            .clipShape(Circle())
            .padding(4)
            .background(colorMyPin)
            .clipShape(Circle())
            .offset(y: -16)
            .overlay(alignment: .bottom) {
                Image(systemName: "triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(colorMyPin)
                    .frame(width: 24)
                    .scaleEffect(y: -1)
                
            }
    }
    private var dropOffView: some View {
        Text("Drop\nOff")
            .foregroundStyle(.white)
            .font(.subheadline)
            .bold()
            .multilineTextAlignment(.center)
            .padding(7)
            .background(.black)
            .clipShape(Circle())
            .padding(4)
            .background(colorMyPin)
            .clipShape(Circle())
            .offset(y: -14)
            .overlay(alignment: .bottom) {
                Image(systemName: "triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(colorMyPin)
                    .frame(width: 24)
                    .scaleEffect(y: -1)
                
            }
    }
}

#Preview {
    DeliveryStepsView(selectedVehicle: .constant(.bicycle),
                      selectedPickupItem: .constant(MKMapItem(placemark: MKPlacemark(coordinate: .locU))),
                      selectedDropOffItem: .constant(MKMapItem(placemark: MKPlacemark(coordinate: .locDropOffDemo))),
                      selectedDriverItem:.constant(MKMapItem(placemark: MKPlacemark(coordinate: .locDriverDemo))),
                      vm: MapViewModel(), isDeliveryStepsStarted: .constant(true),
                      deliveryPercent: 0)
}
