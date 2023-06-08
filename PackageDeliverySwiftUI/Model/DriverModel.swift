//
//  DriverModel.swift
//  package_delivery_SwiftUI_UIKit
//
//  Created by Baris OZGEN on 1.06.2023.
//

import Foundation
struct DriverModel: Identifiable {
    let id: UUID
    let user: UserModel
    let location: LocationModel
    let vehicle: EVehicleType
    let isAvailable: Bool
}
