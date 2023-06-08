//
//  PackageSelection.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 8.06.2023.
//

import SwiftUI

struct PackageSelectionView: View {
    @State var packages: [EPackageType] = [.xs,.s,.m,.l]

    var body: some View {
        ScrollView {
            PackagePackageSection(packages: packages)
        }
    }
}

#Preview {
    PackageSelectionView()
}


struct PackagePackageSection: View {
    var packages: [EPackageType]
    @State var mainID: Int? = nil

    var body: some View {
        PackageSection(edge: .top) {
            PackageContentsView(packages: packages, mainID: $mainID)
        } label: {
            PackageContentHeaderView(packages: packages, mainID: $mainID)
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
        #if os(macOS)
        40.0
        #else
        20.0
        #endif
    }
}

struct PackageContentsView: View {
    var packages: [EPackageType]
    @Binding var mainID: EPackageType.ID?

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: hSpacing) {
                ForEach(packages) { package in
                    PackageHeroView(package: package)
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(.horizontal, hMargin)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $mainID)
        .scrollIndicators(.never)
    }

    var hMargin: CGFloat {
        20.0
    }

    var hSpacing: CGFloat {
        10.0
    }
}

struct PackageHeroView: View {
    var package: EPackageType

    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        
        ZStack{
            colorStack
            Text(package.title)
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
    @Binding var mainID: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 2.0) {
            Text("Package Selection")
                .foregroundStyle(.primary)
            Spacer().frame(maxWidth: .infinity)
        }
        .padding(.horizontal, hMargin)
        #if os(macOS)
        .overlay {
            HStack(spacing: 0.0) {
                PackagePaddle(edge: .leading) {
                    scrollToPreviousID()
                }
                Spacer().frame(maxWidth: .infinity)
                PackagePaddle(edge: .trailing) {
                    scrollToNextID()
                }
            }
        }
        #endif
    }

    private func scrollToNextID() {
        guard let id = mainID, id != packages.last?.id,
              let index = packages.firstIndex(where: { $0.id == id })
        else { return }

        withAnimation {
            mainID = packages[index + 1].id
        }
    }

    private func scrollToPreviousID() {
        guard let id = mainID, id != packages.first?.id,
              let index = packages.firstIndex(where: { $0.id == id })
        else { return }

        withAnimation {
            mainID = packages[index - 1].id
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
