//
//  SearchBarView.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import SwiftUI

struct SearchBarView: View {
    private let defaultSearchText = "Find your favorite Github creator! 🧑🏽‍🎨"
    
    @Binding var committed: Bool
    @Binding var searchText: String
    @State var active = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField(
                    defaultSearchText,
                    text: $searchText,
                    onEditingChanged: { editing in
                        withAnimation {
                            active = editing
                            committed = false
                        }
                    }
                )
                .onSubmit {
                    committed = true
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
            .padding(7)
            .background(Color(white: 0.9))
            .cornerRadius(10)
            
            Button("Cancel") {
                withAnimation {
                    active = false
                    committed = false
                }
            }
            .opacity(active ? 1 : 0)
            .frame(width: active ? nil : 0)
        }
    }
}
