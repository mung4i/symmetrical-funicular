//
//  SearchView.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import SwiftUI

struct SearchView: View {
    
    private let defaultSearchText = "Find your fav Github creator! 🧑🏽‍🎨"
    
    @State private var committed = false
    @State private var searchText = ""
    @State private var page = 1
    @State private var perPage = 10
    
    @StateObject var viewModel = SearchViewModel()
    @SwiftUI.Environment(\.dismissSearch) private var dismissSearch
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(committed: $committed, searchText: $searchText)
                List {
                    ForEach(viewModel.repositories, id: \.self) {
                        CardView(
                            avatar: "",
                            description: $0.description ?? "",
                            name: $0.name,
                            username: $0.defaultBranch
                        )
                    }
                    .listRowSeparator(.hidden, edges: .all)
                }
                .listStyle(.plain)
            }
            .padding(.horizontal, 16)
        }
        .onChange(of: committed) {
            print("committed: \(committed)")
            if searchText != "" {
                viewModel.fetchRepositories(
                    username: searchText,
                    page: page,
                    perPage: perPage
                )
                searchText = ""
            }
        }
    }
}

#Preview {
    SearchView()
}
