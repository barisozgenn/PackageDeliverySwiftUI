//
//  HomeView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 6.06.2023.
//

import SwiftUI
import MapKit


struct HomeView: View {
    
    @State private var selectedItem: MKMapItem?

    
    var body: some View {
        ZStack{
            MapView(selectedItem: $selectedItem)
            Text("\(selectedItem?.name ?? "none")")
        }
        
        
    }
}

#Preview {
    HomeView()
}
