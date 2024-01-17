//
//  SearchRequest.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import Foundation

enum SearchRequestError: Error {
    case wrongResponse
}

enum Sort: String, Codable {
    case created
    case updated
    case pushed
    case fullName = "full_name"
}

struct SearchRequest: ApiRequest {
    
    let page: Int
    let perPage: Int
    let sort: Sort
    let username: String
    
    var endpoint: String { "users/\(username)/repos" }
    
    var method: HTTPMethod { .get }
    
    var headers: [String : String] { [:] }
    
    public var queryParameters: [String: String] {
        [
            "type": "public",
            "page": "\(page)",
            "per_page": "\(perPage)",
            "sort": "\(sort.rawValue)"
        ]
    }
    
    func response(
        for environment: ApiEnvironment,
        networkClient: NetworkClient
    ) async throws -> Repositories? {
        
        switch environment {
        case .mock:
            return Repository.loadFromURL(filename: "repos")
        default:
            return nil
        }
    }
}
