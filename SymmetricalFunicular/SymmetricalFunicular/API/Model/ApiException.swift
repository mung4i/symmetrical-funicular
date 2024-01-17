//
//  ApiException.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import Foundation

public enum ApiException: Error {
    
    /// An error coming from the backend service. It can contain an error code, a message and a list with errors.
    case apiError(ErrorResponse)
    
    /// Defines a network error. Failing connection for example.
    case networkError(NetworkError)
    
    /// Defines an unknown error.
    case unknownError
    
}
