//
//  SearchService.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import Foundation

protocol SearchService: ApiService {
    
    func search(
        username: String,
        page: Int?,
        perPage: Int?,
        sort: Sort
    ) async throws -> Repositories?
}
