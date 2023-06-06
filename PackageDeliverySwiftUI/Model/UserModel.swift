//
//  UserModel.swift
//  package_delivery_SwiftUI_UIKit
//
//  Created by Baris OZGEN on 1.06.2023.
//

import Foundation

struct UserModel {
    let name: String
    let surname: String
    let phoneNumber: String
    var email: String? = ""
    let userType: EUserType
}
