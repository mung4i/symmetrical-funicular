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
            do {
                repositories = try await searchService.search(
                    username: username,
                    page: page,
                    perPage: perPage,
                    sort: sort
                ) ?? []
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
