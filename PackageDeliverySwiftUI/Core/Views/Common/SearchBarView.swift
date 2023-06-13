//
//  SearchBarView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 12.06.2023.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText : String
    
    var body: some View {
        InputView(searchText: $searchText, icon: .constant("magnifyingglass"), placeHolder: .constant("Search drop off location..."))
        .ignoresSafeArea(edges: [.bottom])
        .background(LinearGradient.gradientWalk.opacity(0.58))
        .padding(.top, 7)
    }
}

#Preview  {
   SearchBarView(searchText: .constant("asd"))
}
