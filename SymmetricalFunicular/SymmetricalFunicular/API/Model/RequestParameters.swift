//
//  RequestParameters.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import Foundation

public struct RequestParameters {
    public init(
        _ networkClient: NetworkClient,
        _ environment: ApiEnvironment
    ) {
        self.networkClient = networkClient
        self.environment = environment
    }
    
    let networkClient: NetworkClient
    let environment: ApiEnvironment
}
