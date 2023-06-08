//
//  PackageType.swift
//  package_delivery_SwiftUI_UIKit
//
//  Created by Baris OZGEN on 1.06.2023.
//

import Foundation

enum EPackageType: Int, CaseIterable, Identifiable {
    case xs
    case s
    case m
    case l
    
    var id : Int { return rawValue}
    
    var pricePerKm: Double {
        switch self {
        case .xs:
            return 0.5
        case .s:
            return 1.0
        case .m:
            return 1.5
        case .l:
            return 2.0
        }
    }
    var maxKg: Double {
        switch self {
        case .xs:
            return 5
        case .s:
            return 25.0
        case .m:
            return 200
        case .l:
            return 999.0
        }
    }
    var title: String {
        switch self {
        case .xs: return "XS"
        case .s: return "S"
        case .m: return "M"
        case .l: return "L"
        }
    }
    var boxSize: String {
        switch self {
        case .xs: return "40x40x40"
        case .s: return "70x80x80"
        case .m: return "120x70x90"
        case .l: return "180x100x90"
        }
    }
    var boxPicture: String {
        switch self {
        case .xs: return "40x40x40"
        case .s: return "70x80x80"
        case .m: return "120x70x90"
        case .l: return "180x100x90"
        }
    }
}
