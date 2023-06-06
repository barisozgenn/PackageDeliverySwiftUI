//
//  VehicleTypeModel.swift
//  package_delivery_SwiftUI_UIKit
//
//  Created by Baris OZGEN on 1.06.2023.
//

import Foundation
enum EVehicleType {
    case bicycle
    case scooter
    case car
    case van
    var pricePerKm: Double {
        switch self {
        case .bicycle:
            return 1.5
        case .scooter:
            return 2.0
        case .car:
            return 3.5
        case .van:
            return 5.0
        }
    }
    var speedKmHour: Double {
        switch self {
        case .bicycle:
            return 15.0
        case .scooter:
            return 30.0
        case .car:
            return 100
        case .van:
            return 80
        }
    }
    var title: String {
        switch self {
        case .bicycle: return "Bicycle"
        case .scooter: return "Scooter"
        case .car: return "Car"
        case .van: return "Van"
        }
    }
    var maxPackageLimit: EPackageType {
        switch self {
        case .bicycle:
            return .s
        case .scooter:
            return .s
        case .car:
            return .m
        case .van:
            return .l
        }
    }
    var cantWork: [EWeatherType] {
        switch self {
        case .bicycle:
            return [.snow, .rain, .tooHot]
        case .scooter:
            return [.snow]
        case .car:
            return []
        case .van:
            return []
        }
    }
}
