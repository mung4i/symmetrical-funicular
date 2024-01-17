//
//  SearchView.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import SwiftUI

struct SearchView: View {
    
    
    @State private var searchText = "Find your favorite Github creator! 🧑🏽‍🎨"
    var body: some View {
        NavigationStack {
            VStack {
                
            }
            .padding(.horizontal, 16)
        }
        .searchable(text: $searchText)
        
    }
}

#Preview {
    SearchView()
}
