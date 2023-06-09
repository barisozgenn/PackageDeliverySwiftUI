//
//  LocationDetailView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 7.06.2023.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    var selectedItem: MKMapItem
    @Bindable var vm : MapViewModel
    
    var travelTime: String? {
        guard let route = vm.route else { return nil }
        let formatter = DateComponentsFormatter ()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string (from: route.expectedTravelTime)
    }
    
    var body: some View {
        LookAroundPreview(initialScene: vm.lookAroundScene)
            .overlay(alignment: .bottomLeading){
                VStack(alignment: .leading){
                    Text("Hey Baris!")
                        .shadow(color: .black, radius: 2, x:0, y:2)
                        .font(.title)
                    Text("Confirm the pickup location for your package.")
                        .shadow(color: .black, radius: 2, x:0, y:2)
                        .font(.title3)
                    HStack{
                        Text(selectedItem.name ?? "not selected")
                            .shadow(color: .black, radius: 2, x:0, y:2)

                        if let travelTime {
                            Text(travelTime)
                        }
                    }
                    confirmButton
                }
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 2, x:0, y:2)
                .foregroundStyle(.white)
                .fontDesign(.rounded)
                .fontWidth(.expanded)
                .padding()
                .padding(.bottom, 58)
                .background(.black.opacity(0.29))
            }
            .onAppear{
                vm.getLookAroundScene(selectedItem: selectedItem)
                vm.getDirections(to: selectedItem)
            }
        //.background(.thinMaterial)
            .presentationDetents([.fraction(0.29)])
            .ignoresSafeArea()
    }
}

extension LocationDetailView{
    private var confirmButton : some View {
        Button(action: {}) {
            HStack{
                Spacer()
                Text("Confirm")
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
}
#Preview {
    LocationDetailView(selectedItem: MKMapItem(placemark: MKPlacemark(coordinate: .loc1)), vm: MapViewModel())
}
