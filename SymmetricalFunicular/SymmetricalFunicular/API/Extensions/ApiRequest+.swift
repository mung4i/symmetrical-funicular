//
//  ApiRequest+.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import Foundation

extension ApiRequest {
    
    /// Executes an API call.
    ///
    /// - Parameters:
    ///    - networkClient: the network client to use. It could be real or mock.
    ///    - environment: determines whether to use live or mock environment.
    ///
    /// - Returns: the backend response encoded by using the infered request response type.
    /// - Throws: An ApiError exception containing all the information from the server.
    ///
    public func doRequest(_ params: RequestParameters) async throws -> ResponseType? {
        
        if let response = try await response(
            for: params.environment,
            networkClient: params.networkClient
        ) {
            return response
        }
        
        // for envs .live or .failing it should try to send data
        if params.environment != .mock {
            do {
                return try await doLiveRequest(params)
            } catch ApiException.unknownError {
                throw ApiException.networkError(.invalidResponse)
            }
        }
        throw ApiException.networkError(.invalidResponse)
    }
    
    /// Executes an API call.
    ///
    /// - Parameters:
    ///    - networkClient: the network client to use. It could be real or mock.
    ///    - environment: determines whether to use live or mock environment.
    ///
    /// - Returns: the backend response encoded by using the infered request response type.
    /// - Throws: An ApiError exception containing all the information from the server.
    ///
    public func doRequest(
        _ params: RequestParameters,
        queryParameters: [String: String]
    ) async throws -> ResponseType? {
        
        if let response = try await response(
            for: params.environment,
            networkClient: params.networkClient
        ) {
            return response
        }
        
        // for envs .live or .failing it should try to send data
        if params.environment != .mock {
            do {
                return try await doLiveRequest(
                    params,
                    queryParameters: queryParameters
                )
            } catch ApiException.unknownError {
                throw ApiException.networkError(.invalidResponse)
            }
        }
        throw ApiException.networkError(.invalidResponse)
    }
    
    /// Internal Function to perform the request using the network client
    /// - Parameter params: Request parameters responsible used to execute the request
    /// - Parameter queryParams: Dictionary containing queryParams
    /// - Parameter hasBody: Determines whether request has a body
    /// - Returns: A decodable response for processing
    func doLiveRequest(
        _ params: RequestParameters,
        queryParameters: [String: String] = [:],
        hasBody: Bool = false
    ) async throws -> ResponseType {
        
        let jsonData = try JSONEncoder().encode(self)
        let result = await params.networkClient.request(
            endpoint: "/" + endpoint,
            method: method,
            headers: [:],
            body: hasBody ? jsonData : nil,
            expecting: ResponseType.self,
            queryParameters: queryParameters
        )
        
        switch result {
        case let .failure(error):
            switch error {
            case let .fail(data, _):
                
                let decoder = JSONDecoder()
                
                guard let error = try? decoder.decode(ErrorResponse.self, from: data) else {
                    throw ApiException.unknownError
                }
                
                throw ApiException.apiError(error)
            default:
                throw ApiException.networkError(error)
            }
        case let .success(data):
            return data
        }
    }
}
