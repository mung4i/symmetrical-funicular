//
//  SearchView.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import SwiftUI

struct SearchView: View {
    private let defaultSearchText = "Find your fav Github creator! 🧑🏽‍🎨"
    
    @State private var searchText = ""

    @StateObject var viewModel = SearchViewModel()
    
    @SwiftUI.Environment(\.colorScheme) private var colorScheme
    @SwiftUI.Environment(\.dismissSearch) private var dismissSearch
    
    private var repositoriesScreen: some View {
        VStack {
            if viewModel.showEmptyState() {
                Spacer()
                EmptyStateView(title: "No more repositories to browse")
                Spacer()
            } else {
                repositoriesView
            }
        }
    }
    
    private var repositoriesView: some View {
        ScrollViewReader { proxy in
            VStack {
                List {
                    ForEach(
                        (0..<viewModel.repositories.count),
                        id: \.self
                    ) { index in
                        let element = viewModel.repositories[index]
                        CardView(
                            avatar: element.owner.avatarURL,
                            description: element.description ?? "",
                            name: element.name,
                            username: element.owner.login,
                            language: element.language ?? "",
                            starGazersCount: element.stargazersCount
                        )
                        .id(index)
                    }
                    .listRowSeparator(.hidden, edges: .all)
                }
                .listStyle(.plain)
                .onChange(of: viewModel.repositories) {
                    proxy.scrollTo(0)
                }
            }
            .transition(.identity)
            .animation(.linear, value: viewModel.repositories)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(committed: $viewModel.committed, searchText: $searchText)
                
                HStack {
                    Picker("Items per page", selection: $viewModel.perPage) {
                        ForEach(viewModel.itemsPerPage, id: \.self) { item in
                            Text("Items per page: \(item)")
                                .tag(item)
                        }
                    }
                    
                    Picker("Sort", selection: $viewModel.sort) {
                        ForEach(viewModel.allCases, id: \.self) {
                            Text("Sort: \(viewModel.allCasesDescription($0))")
                                .tag($0)
                        }
                    }
                }
                .padding(8)
                .background(.gray.opacity(0.5))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .cornerRadius(10)
                
                Spacer()
                
                if viewModel.isLoading {
                    VStack(alignment: .center) {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else {
                    repositoriesScreen
                    PaginationView(
                        isRightButtonEnabled: viewModel.isIncrementEnabled(),
                        isLeftButtonEnabled: viewModel.isDecrementEnabled(),
                        rightAction: { viewModel.incrementPage() },
                        leftAction: { viewModel.decrementPage() }
                    )
                    .padding(.bottom, 8)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image(colorScheme == .dark ? "github-dark-logo" : "github-light-logo")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }
        }
        .onChange(of: viewModel.committed) {
            if searchText != "" {
                viewModel.fetchRepositories(
                    username: searchText
                )
                searchText = ""
            }
        }
        .onChange(of: viewModel.sort) {
            viewModel.updateSearchParameters()
        }
        .onChange(of: viewModel.perPage) {
            viewModel.updateSearchParameters()
        }
        .alert(isPresented: $viewModel.hasError) {
            Alert(
                title: Text("Something went wrong"),
                message: Text("Ensure you are searching for a valid repository name"),
                dismissButton: .default(
                    Text("Got it!"),
                    action: {
                        viewModel.hasError = false
                    }
                )
            )
        }
    }
}

#Preview {
    SearchView()
}
