//
//  EWeatherType.swift
//  package_delivery_SwiftUI_UIKit
//
//  Created by Baris OZGEN on 1.06.2023.
//

import Foundation
enum EWeatherType {
    case cold
    case warm
    case moderate
    case dryOrHumid
    case snow
    case rain
    case tooHot
    var title: String {
        switch self {
        case .cold:
            return "Cold"
        case .warm:
            return "Warm"
        case .moderate:
            return "Moderate"
        case .dryOrHumid:
            return "Dry or Humid"
        case .snow:
            return "Snow"
        case .rain:
            return "Rain"
        case .tooHot:
            return "Too Hot"
        }
    }
    var image: String {
        switch self {
        case .cold:
            return "wind.snow"
        case .warm:
            return "cloud.sun"
        case .moderate:
            return "sun.max"
        case .dryOrHumid:
            return "sun.dust"
        case .snow:
            return "cloud.snow"
        case .rain:
            return "cloud.sun.rain"
        case .tooHot:
            return "sun.max.trianglebadge.exclamationmark"
        }
    }
    var recommendedTemperature: (min: Int, max: Int) {
        switch self {
        case .cold:
            return (min: 6, max: 20)
        case .warm:
            return (min: 21, max: 25)
        case .moderate:
            return (min: 22, max: 26)
        case .dryOrHumid:
            return (min: 26, max: 35)
        case .snow:
            return (min: -30, max: 0)
        case .rain:
            return (min: 1, max: 23)
        case .tooHot:
            return (min: 35, max: 40)
        }
    }
    var difficulty: Int {
        switch self {
        case .cold:
            return 1
        case .warm:
            return 0
        case .moderate:
            return 0
        case .dryOrHumid:
            return 0
        case .snow:
            return 3
        case .rain:
            return 2
        case .tooHot:
            return 3
        }
    }
}
