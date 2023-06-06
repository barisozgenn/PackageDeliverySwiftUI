//
//  DeliveryStatusModel.swift
//  package_delivery_SwiftUI_UIKit
//
//  Created by Baris OZGEN on 1.06.2023.
//

import Foundation

struct DeliveryStatusModel {
    let status: EDeliveryStatus
    let dateTime: Date
    internal enum EDeliveryStatus {
       case findingDriver
       case driverComing
       case driverOnRoad
       case packageDelivered
       case cancelled
    }
}
