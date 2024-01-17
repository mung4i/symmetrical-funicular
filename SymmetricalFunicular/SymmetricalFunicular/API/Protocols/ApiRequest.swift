//
//  ApiRequest.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import Foundation

/// A base protocol for all API requests
///
public protocol ApiRequest: Encodable {
    
    /// Defines the response type. It is infered when implementing the response:for: method
    associatedtype ResponseType: Decodable
    
    /// The API server path. The full path is constructed by concatenating the existing baseUrl from network client environment.
    var endpoint: String { get }
    
    /// The HTTP method to use.
    var method: HTTPMethod { get }
    
    /// A dictionary containing all request headers
    var headers: [String: String] { get }
    
    
    /// This method is called before processing any request. If it returns a non-nil result, the processing stops and the call returns the value obtained by this method
    ///
    /// - Parameters:
    ///     - environment: Determines whether to use live or mock environment.
    ///     - networkClient: The network client.
    ///
    /// - Returns: The server response
    /// - Throws: An ApiError containing all backend error information coming from the server.
    ///
    func response(
        for environment: ApiEnvironment,
        networkClient: NetworkClient
    ) async throws -> ResponseType?
}
