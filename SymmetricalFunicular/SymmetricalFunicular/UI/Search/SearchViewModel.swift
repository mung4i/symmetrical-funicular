//
//  SearchViewModel.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import Foundation
import SwiftUI

class SearchViewModel: ObservableObject {
        
    @Published var repositories: Repositories = []
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    
    private var searchService: SearchService {
        SearchServiceImpl()
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
            try await Task.sleep(nanoseconds: 1_000_000_000)
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
