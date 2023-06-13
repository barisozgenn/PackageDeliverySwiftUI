//
//  PackagesSection.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 9.06.2023.
//

import SwiftUI

struct PackagesSection: View {
    var packages: [EPackageType]
    @Binding var selectionId: EPackageType.ID?
    
    var body: some View {
        PackageSection(edge: .top) {
            PackageContentsView(packages: packages, selectionId: $selectionId)
        } label: {
            PackageContentHeaderView(packages: packages, selectionId: $selectionId)
        }
    }
}

struct PackageSection<Content: View, Label: View>: View {
    var edge: Edge? = nil
    @ViewBuilder var content: Content
    @ViewBuilder var label: Label
    
    var body: some View {
        VStack(alignment: .leading) {
            label
                .font(.title2.bold())
            content
        }
        .padding(.top, halfSpacing)
        .padding(.bottom, sectionSpacing)
        .overlay(alignment: .bottom) {
            if edge != .bottom {
                Divider().padding(.horizontal, hMargin)
            }
        }
    }
    
    var halfSpacing: CGFloat {
        sectionSpacing / 2.0
    }
    
    var sectionSpacing: CGFloat {
        20.0
    }
    
    var hMargin: CGFloat {
        20.0
    }
}




#Preview {
    PackagesSection(packages: EPackageType.allCases, selectionId: .constant(nil))
}
