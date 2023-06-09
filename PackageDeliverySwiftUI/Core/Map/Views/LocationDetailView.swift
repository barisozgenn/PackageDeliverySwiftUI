//
//  LocationDetailView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 7.06.2023.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    @State var selectedItem: MKMapItem = MKMapItem(placemark: MKPlacemark(coordinate: .loc1))
    @Bindable var vm : MapViewModel
    
    var travelTime: String? {
       /* guard let vm.route else { return nil }
        let formatter = DateComponentsFormatter ()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string (from: vm.route.expectedTravelTime)*/
        return "3m"
    }
    
    var body: some View {
        LookAroundPreview(initialScene: vm.lookAroundScene)
            .overlay(alignment: .bottomLeading){
                VStack(alignment: .leading){
                    Text("Hey Baris!")
                        .font(.title)
                    Text("Confirm the pickup location for your package.")
                        .font(.title3)
                    HStack{
                        Text(selectedItem.name ?? "not selected")
                        if let travelTime {
                            Text(travelTime)
                        }
                    }
                }
                .foregroundStyle(.white)
                .fontDesign(.rounded)
                .fontWidth(.expanded)
                .padding()
                .padding(.bottom, 58)
            }
            .onAppear{
                vm.getLookAroundScene(selectedItem: selectedItem)
                vm.getDirections(selectedItem: selectedItem)
            }
        //.background(.thinMaterial)
            .presentationDetents([.fraction(0.29)])
            .ignoresSafeArea()
    }
}

#Preview {
    LocationDetailView(vm: MapViewModel())
}
