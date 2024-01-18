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
    @State private var page = 1
    @State private var perPage = 10
    @State private var previousSearchText = ""
    @State private var sort: Sort = .pushed
    @State private var searchText = ""
    @State private var showSettingsMenu = false
    var itemsPerPage = [5, 10, 15 , 20]
    var allCases: [Sort] {
        [
            .created,
            .updated,
            .pushed,
            .fullName
        ]
    }
    
    func allCasesDescription(_ sortCase: Sort) -> String {
        switch sortCase {
        case .created:
            return "Created"
        case .updated:
            return "Updated"
        case .pushed:
            return "Pushed"
        case .fullName:
            return "Full Name"
        }
    }

    @StateObject var viewModel = SearchViewModel()
    
    @SwiftUI.Environment(\.colorScheme) private var colorScheme
    @SwiftUI.Environment(\.dismissSearch) private var dismissSearch
    
    private var repositories: some View {
        ScrollViewReader { proxy in
            VStack {
                List {
                    ForEach(
                        Array(viewModel.repositories.enumerated()),
                        id: \.offset
                    ) { index, element in
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
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(committed: $committed, searchText: $searchText)
                
                HStack {
                    Picker("Items per page", selection: $perPage) {
                        ForEach(itemsPerPage, id: \.self) { item in
                            Text("Items per page: \(item)")
                                .tag(item)
                        }
                    }
                    
                    Picker("Sort", selection: $sort) {
                        ForEach(allCases, id: \.self) {
                            Text("Sort: \(allCasesDescription($0))")
                                .tag($0)
                        }
                    }
                }
                .padding(8)
                .background(.gray.opacity(0.5))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .cornerRadius(10)
                
                if viewModel.isLoading {
                    VStack(alignment: .center) {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else {
                    repositories
                    PaginationView(
                        isRightButtonEnabled: isIncrementEnabled(),
                        isLeftButtonEnabled: isDecrementEnabled(),
                        rightAction: { incrementPage() },
                        leftAction: { decrementPage() }
                    )
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
        .onChange(of: committed) {
            if searchText != "" {
                previousSearchText = searchText
                viewModel.fetchRepositories(
                    username: searchText,
                    page: page,
                    perPage: perPage,
                    sort: sort
                )
                searchText = ""
            }
        }
        .onChange(of: sort) {
            updateSearchParameters()
        }
        .onChange(of: perPage) {
            updateSearchParameters()
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
    
    private func isIncrementEnabled() -> Bool {
        return page >= 1
    }
    
    private func isDecrementEnabled() -> Bool {
        return page > 1
    }
    
    private func incrementPage() {
        guard isIncrementEnabled() else {
            return
        }
        
        page = page + 1
        updateSearchParameters()
    }
    
    private func decrementPage() {
        guard isDecrementEnabled() else {
            return
        }
        
        page = page - 1
        updateSearchParameters()
    }
    
    private func updateSearchParameters() {
        if previousSearchText != "" {
            viewModel.fetchRepositories(
                username: previousSearchText,
                page: page,
                perPage: perPage,
                sort: sort
            )
        }
    }
}

#Preview {
    SearchView()
}
