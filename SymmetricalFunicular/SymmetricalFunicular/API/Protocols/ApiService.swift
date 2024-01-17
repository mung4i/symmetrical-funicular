//
//  APIService.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import Foundation

/**
 A base protocol for all API services
 */
protocol ApiService {
    
    /// The NetworkClient to use to communicate with the backend.
    var networkClient: NetworkClient { get }
    
    /// The ApiEnvironment to use when communicating with the backend.
    var apiEnvironment: ApiEnvironment { get }
    
}
