//
//  SearchViewModel.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import Foundation
import SwiftUI

class SearchViewModel: ObservableObject {
     
    @Published var committed = false
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var page = 1
    @Published var perPage = 10
    @Published var previousSearchText = ""
    @Published var repositories: Repositories = []
    @Published var sort: Sort = .pushed

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
    
    private func resetPageCount(_ username: String) {
        if (previousSearchText != "") &&
            (previousSearchText != username) {
            self.page = 1
        }
    }
    
    @MainActor
    func fetchRepositories(
        username: String
    ) {
        // Reset pageCount
        resetPageCount(username)
        previousSearchText = username
        Task {
            isLoading = true
            // Checking loading state
//             try await Task.sleep(nanoseconds: 500_000_000)
            do {
                isLoading = false
                repositories = try await searchService.search(
                    username: username,
                    page: self.page,
                    perPage: perPage,
                    sort: sort
                ) ?? []
            } catch {
                isLoading = false
                hasError = true
            }
        }
    }
    
    func isIncrementEnabled() -> Bool {
        if repositories.isEmpty {
            return false
        }
        return page >= 1
    }
    
    func isDecrementEnabled() -> Bool {
        if page == 1 {
            return false
        }
        
        if previousSearchText != "" {
            return true
        }
        
        if repositories.isEmpty && previousSearchText == "" {
            return false
        }
        
        return page > 1
    }
    
    func showEmptyState() -> Bool {
        previousSearchText != "" &&
            repositories.isEmpty &&
            page != 1
    }
    
    @MainActor 
    func incrementPage() {
        guard isIncrementEnabled() else {
            return
        }
        
        page = page + 1
        updateSearchParameters()
    }
    
    @MainActor func decrementPage() {
        guard isDecrementEnabled() else {
            return
        }
        
        page = page - 1
        updateSearchParameters()
    }
    
    @MainActor
    func updateSearchParameters() {
        if previousSearchText != "" {
            fetchRepositories(username: previousSearchText)
        }
    }
}
