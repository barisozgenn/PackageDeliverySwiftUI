//
//  PackageContentsView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 9.06.2023.
//

import SwiftUI

struct PackageContentsView: View {
    var packages: [EPackageType]
    @Binding var selectionId: EPackageType.ID?
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: hSpacing) {
                ForEach(packages) { package in
                    PackageDetailView(package: package)
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(.horizontal, hMargin)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $selectionId)
        .scrollIndicators(.never)
       
    }
    
    var hMargin: CGFloat {
        20.0
    }
    
    var hSpacing: CGFloat {
        10.0
    }
}

struct PackageDetailView: View {
    var package: EPackageType
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    var body: some View {
        
        ZStack{
            colorStack
            HStack(alignment: .center){
                VStack{
                    Image(systemName: "shippingbox.fill")
                        .resizable()
                        .frame(width: 128 + (package.maxHeight * 0.3),height: package.maxHeight)
                    Text(package.title)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                }
                .foregroundStyle(.orange)
                Spacer()
                VStack{
                    VStack(alignment: .trailing){
                        Text("max")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .bold()
                            .foregroundStyle(.orange)
                        Text("\(Int(package.maxKg))kg")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(Color(.systemGray))
                        Text("size")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.orange)
                        Text(package.boxSize)
                            .font(.title3)
                            .bold()
                            .foregroundStyle(Color(.systemGray))
                    }
                    
                }
                
            }
            .padding(.all)
            .padding(.trailing,40)
            .offset(y: -20)
            
        }
        .aspectRatio(heroRatio, contentMode: .fit)
        .containerRelativeFrame(
            [.horizontal], count: columns, spacing: hSpacing
        )
        .clipShape(.rect(cornerRadius: 29.0))
        .scrollTransition(axis: .horizontal) { content, phase in
            content
                .scaleEffect(
                    x: phase.isIdentity ? 1.0 : 0.7,
                    y: phase.isIdentity ? 1.0 : 0.7)
        }
    }
    
    private var columns: Int {
        sizeClass == .compact ? 1 : regularCount
    }
    
    @ViewBuilder
    private var colorStack: some View {
        let offsetValue = stackPadding
        ZStack {
            Color(.systemGray2)
                .offset(x: offsetValue, y: offsetValue)
            Color(.systemGray4)
            Color(.systemGray6)
                .offset(x: -offsetValue, y: -offsetValue)
            
        }
        .padding(stackPadding)
        .background()
    }
    
    var stackPadding: CGFloat {
        20.0
    }
    
    var heroRatio: CGFloat {
        16.0 / 9.0
    }
    
    var regularCount: Int {
        2
    }
    
    var hSpacing: CGFloat {
        10.0
    }
}

#Preview {
    PackageContentsView(packages: EPackageType.allCases, selectionId: .constant(nil))
}
