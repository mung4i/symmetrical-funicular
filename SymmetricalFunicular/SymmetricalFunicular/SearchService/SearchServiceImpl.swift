//
//  SearchServiceImpl.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import Foundation

class SearchServiceImpl: SearchService {
    
    var networkClient: NetworkClient
    var apiEnvironment: ApiEnvironment
    
    init(
        networkClient: NetworkClient = NetworkClientImpl(),
        apiEnvironment: ApiEnvironment = .live
    ) {
        self.networkClient = networkClient
        self.apiEnvironment = apiEnvironment
    }
}


extension SearchServiceImpl {
    
    func search(username: String, page: Int?, perPage: Int?, sort: Sort) async throws -> Repositories? {
        let defaultPage = 1
        let defaultPerPage = 10
        let request = SearchRequest(
            page: page ?? defaultPage,
            perPage: perPage ?? defaultPerPage,
            sort: sort,
            username: username
        )
        
        do {
            guard let response = try await sendRequest(
                request,
                queryParameters: request.queryParameters
            ) else {
                throw SearchRequestError.wrongResponse
            }
            return response
        } catch let ApiException.apiError(response) {
            throw ApiException.apiError(response)
        }
    }
}

extension SearchServiceImpl: ApiService {
    public func sendRequest<T>(
        _ request: T,
        queryParameters: [String: String] = [:]
    ) async throws -> T.ResponseType? where T: ApiRequest {
        let params = RequestParameters(networkClient, apiEnvironment)
        return try await request.doRequest(params, queryParameters: queryParameters)
    }
}
