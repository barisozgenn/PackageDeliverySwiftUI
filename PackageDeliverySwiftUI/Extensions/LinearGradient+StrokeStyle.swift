//
//  LinearGradiendt+StrokeStyle.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 9.06.2023.
//

import SwiftUI

extension LinearGradient {
    static let gradientWalk = LinearGradient(
        colors: [.red, .orange, .yellow],
        startPoint: .leading, endPoint: .trailing)
    
    static let gradientDrive = LinearGradient(
        colors: [.blue, .green],
        startPoint: .leading, endPoint: .trailing)
}

extension RadialGradient {
    static let gradientDoneSteps = RadialGradient(colors: [.red, .orange, .yellow], center: .center,startRadius: 0,endRadius: 64)
    static let gradientWaitedSteps = RadialGradient(colors: [.gray, Color(.systemGray3)], center: .center,startRadius: 0,endRadius: 64)
}
extension StrokeStyle {
    static let strokeWalk = StrokeStyle(
        lineWidth: 5,
        lineCap: .round, lineJoin: .bevel, dash: [10, 10])
}
