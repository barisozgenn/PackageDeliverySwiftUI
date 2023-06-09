//
//  PackageSelection.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 8.06.2023.
//

import SwiftUI

struct PackageSelectionView: View {
    @State var packages: [EPackageType] = EPackageType.allCases//[.xs,.s,.m,.l]
    @State var selectionId: EPackageType.ID? = EPackageType.xs.id
    @State var buttonText = EPackageType.xs.title
    var body: some View {
        ScrollView {
            PackagesSection(packages: packages, selectionId: $selectionId)
            Button(action: {}) {
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
            .onChange(of: selectionId){ oldOne, newOne in
                buttonText = packages.first(where: {$0.id == newOne})!.title
            }
        }
        .padding(.top)
        .background(.clear)
    }
}

#Preview {
    PackageSelectionView()
}


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

struct PackageContentHeaderView: View {
    var packages: [EPackageType]
    @Binding var selectionId: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2.0) {
            Text("Package Selection")
                .foregroundStyle(.primary)
                .font(.title2)
                .bold()
            Text("Please select the package type for your intended delivery.")
                .foregroundStyle(.secondary)
                .font(.headline)
            Spacer().frame(maxWidth: .infinity)
        }
        .padding(.horizontal, hMargin)
    }
    
    private func scrollToNextID() {
        guard let id = selectionId, id != packages.last?.id,
              let index = packages.firstIndex(where: { $0.id == id })
        else { return }
        
        withAnimation {
            selectionId = packages[index + 1].id
        }
    }
    
    private func scrollToPreviousID() {
        guard let id = selectionId, id != packages.first?.id,
              let index = packages.firstIndex(where: { $0.id == id })
        else { return }
        
        withAnimation {
            selectionId = packages[index - 1].id
        }
    }
    
    var hMargin: CGFloat {
        20.0
    }
}

struct PackagePaddle: View {
    var edge: HorizontalEdge
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Label(labelText, systemImage: labelIcon)
        }
        .buttonStyle(.paddle)
        .font(nil)
    }
    
    var labelText: String {
        switch edge {
        case .leading:
            return "Backwards"
        case .trailing:
            return "Forwards"
        }
    }
    
    var labelIcon: String {
        switch edge {
        case .leading:
            return "chevron.backward"
        case .trailing:
            return "chevron.forward"
        }
    }
}

private struct PaddleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .imageScale(.large)
            .labelStyle(.iconOnly)
    }
}

extension ButtonStyle where Self == PaddleButtonStyle {
    static var paddle: Self { .init() }
}
