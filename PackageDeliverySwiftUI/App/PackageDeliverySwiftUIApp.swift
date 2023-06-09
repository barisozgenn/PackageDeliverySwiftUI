//
//  PackageDeliverySwiftUIApp.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 6.06.2023.
//

import SwiftUI
import SwiftData

@main
struct PackageDeliverySwiftUIApp: App {

    var body: some Scene {
        WindowGroup {
            //HomeView()
            NewMapView()
        }
        .modelContainer(for: Item.self)
    }
}
