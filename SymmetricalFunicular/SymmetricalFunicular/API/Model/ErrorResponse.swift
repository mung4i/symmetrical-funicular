//
//  ErrorResponse.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import Foundation

public struct ErrorResponse: Codable {
    
    // MARK: Instance Properties
    
    public var code: String?
    public var id: String?
    private var message: String?
    
    // MARK: Initialisers
    
    init() {}
}

extension ErrorResponse: Equatable {
    
    static public func == (lhs: ErrorResponse, rhs: ErrorResponse) -> Bool {
        lhs.code == rhs.code &&
        lhs.id == rhs.id &&
        lhs.message == rhs.message
    }
}

extension ErrorResponse: Hashable {}
