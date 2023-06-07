//
//  LocationDetailView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 7.06.2023.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    @Binding var selectedItem: MKMapItem?
    @State private var lookAroundScene: MKLookAroundScene?
    @Binding var route: MKRoute?
    
    private var travelTime: String? {
        guard let route else { return nil }
        let formatter = DateComponentsFormatter ()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string (from: route.expectedTravelTime)
    }
    
    func getLookAroundScene(){
        lookAroundScene = nil
        Task{
          //  if let selectedItem = selectedItem {
                let request = MKLookAroundSceneRequest(mapItem: MKMapItem(placemark: MKPlacemark(coordinate: .loc1)))
                lookAroundScene = try await request.scene
         //   }
        }
    }
    
    func getDirections() {
        route = nil
      //  guard let selectedItem else { return }
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: .loc3))
        request.destination =  MKMapItem(placemark: MKPlacemark(coordinate: .loc1))//selectedItem
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
        }
    }
    var body: some View {
        LookAroundPreview(initialScene: lookAroundScene)
            .overlay(alignment: .bottomLeading){
                VStack(alignment: .leading){
                    Text("Hey Baris!")
                        .font(.title)
                    Text("Confirm the pickup location for your package.")
                        .font(.title3)
                    HStack{
                        Text(selectedItem?.name ?? "not selected")
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
                getDirections()
                getLookAroundScene()
            }
            .onChange(of: selectedItem, {
                getLookAroundScene()
            })
            .onChange(of: selectedItem, {
                getDirections()
            })
            .background(.thinMaterial)
            .presentationDetents([.fraction(0.29)])
            .ignoresSafeArea()
    }
}

#Preview {
    LocationDetailView(selectedItem: .constant(MKMapItem(placemark: MKPlacemark(coordinate: .loc1, addressDictionary: ["title":"Dumbo"]))), route: .constant(MKRoute()))
}
