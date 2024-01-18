//
//  SearchBarView.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import SwiftUI

struct SearchBarView: View {
    @SwiftUI.Environment(\.colorScheme) private var colorScheme

    private let defaultSearchText = "Find your favorite Github creator! 🧑🏽‍🎨"
    
    @Binding var committed: Bool
    @Binding var searchText: String
    @State var active = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
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
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .onSubmit {
                    committed = true
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
                    )
                }
                Button(
                    action: {
                        withAnimation {
                            active = false
                            committed = false
                        }
                        searchText = ""
                    },
                    label: {
                        Image(systemName: "multiply.circle.fill")
                    }
                )
                .padding(.trailing, 4)
                .opacity(searchText != "" ? 1 : 0)
                .frame(width: active ? nil : 0)
            }
            .padding(8)
            .background(.gray.opacity(0.5))
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    SearchBarView(
        committed: .constant(false),
        searchText: .constant(""),
        active: false
    )
}
