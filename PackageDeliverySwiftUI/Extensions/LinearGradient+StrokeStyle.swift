//
//  LinearGradiendt+StrokeStyle.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 9.06.2023.
//

import SwiftUI

extension LinearGradient {
    static let gradientWalk = LinearGradient(
        colors: [.orange, .green, .blue],
        startPoint: .leading, endPoint: .trailing)
    
    static let gradientDrive = LinearGradient(
        colors: [.blue, .green],
        startPoint: .leading, endPoint: .trailing)
    
}

extension StrokeStyle {
    static let strokeWalk = StrokeStyle(
        lineWidth: 5,
        lineCap: .round, lineJoin: .bevel, dash: [10, 10])
}
