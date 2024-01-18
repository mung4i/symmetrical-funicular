//
//  SearchViewModel.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import Foundation
import SwiftUI

class SearchViewModel: ObservableObject {
        
    @Published var repositories: Repositories = [] {
        didSet {
            print(repositories)
        }
    }
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    
    var allCases: [Sort] {
        [
            .created,
            .updated,
            .pushed,
            .fullName
        ]
    }
    
    var itemsPerPage = [5, 10, 15 , 20]
    
    let searchService: SearchService
    
    init(searchService: SearchService = SearchServiceImpl()) {
        self.searchService = searchService
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
    
    @MainActor
    func fetchRepositories(
        username: String,
        page: Int?,
        perPage: Int?,
        sort: Sort = .pushed
    ) {
        Task {
            isLoading = true
//            try await Task.sleep(nanoseconds: 1_000_000_000) uncomment to see loading state
            do {
                isLoading = false
                repositories = try await searchService.search(
                    username: username,
                    page: page,
                    perPage: perPage,
                    sort: sort
                ) ?? []
            } catch {
                isLoading = false
                hasError = true
            }
        }
    }
}
