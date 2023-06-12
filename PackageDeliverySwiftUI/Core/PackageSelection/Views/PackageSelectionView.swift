//
//  PackageSelection.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 8.06.2023.
//

import SwiftUI

struct PackageSelectionView: View {
    @State var packages: [EPackageType] = EPackageType.allCases//[.xs,.s,.m,.l]
    @State var selectionId: EPackageType.ID? = 0
    @State var buttonText: String = ""
    @Binding var selectedPackage: EPackageType?

    var body: some View {
        ScrollView {
            PackagesSection(packages: packages, selectionId: $selectionId)
            Button(action: {
                if selectionId != nil {
                    selectedPackage = packages.first(where: {$0.id == selectionId})
                }
            }) {
                VStack{
                    Text("Choose \(buttonText)")
                        .foregroundStyle(.white)
                        .bold()
                }
                .padding()
                .padding(.horizontal, 29)
                .background(.blue)
                .clipShape(.rect(cornerRadius: 14.0))
            }
            .onAppear{
                /*if let newId = selectionId {
                    buttonText =  packages.first(where: {$0.id == newId})!.title
                }*/
            }
            .onChange(of: selectionId){
                if let newId = selectionId {
                    buttonText =  packages.first(where: {$0.id == newId})!.title
                }
            }
        }
        .padding(.top)
        .background(.clear)
    }
}

#Preview {
    PackageSelectionView(selectedPackage: .constant(nil))
}
