//
//  LocationDetailView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 7.06.2023.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    @State var selectedItem: MKMapItem
    @Bindable var vm : MapViewModel
    @Binding var stepsDone: [EDeliveryChoiceSteps]
    
    @State var aptNumber: String = ""
    @State var nameSurname: String = ""
    @State var phoneNumber: String = ""
    
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
                    Text("Confirm the \(!stepsDone.contains(.pickup) ? "pickup" : "drop off") location for your package.")
                        .shadow(color: .black, radius: 2, x:0, y:2)
                        .font(.title3)
                    HStack{
                        Text(selectedItem.name ?? "not selected")
                            .shadow(color: .black, radius: 2, x:0, y:2)

                        if let travelTime {
                            Text(travelTime)
                        }
                    }
                    if stepsDone.contains(.pickup) {
                        dropOffView
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
            .presentationDetents([.fraction(0.29)])
            .ignoresSafeArea()
    }
}

extension LocationDetailView{
    private var confirmButton : some View {
        Button(action: {
            !stepsDone.contains(.pickup) ? stepsDone.append(.pickup) : stepsDone.append(.dropoff)
        }) {
            HStack{
                Spacer()
                Text("Confirm \(!stepsDone.contains(.pickup) ? "Pickup" : "Drop Off")")
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
    private var dropOffView: some View {
        VStack(spacing: 0){
            InputView(searchText: $aptNumber, icon: .constant("building.2"), placeHolder: .constant("Apt. Number"))
            InputView(searchText: $nameSurname, icon: .constant("person"), placeHolder: .constant("Name Surname"))
            InputView(searchText: $phoneNumber, icon: .constant("phone.and.waveform"), placeHolder: .constant("Phone Number"))
        }
    }
}
#Preview {
    LocationDetailView(selectedItem: MKMapItem(placemark: MKPlacemark(coordinate: .loc1)), vm: MapViewModel(), stepsDone: .constant([.pickup]))
}
