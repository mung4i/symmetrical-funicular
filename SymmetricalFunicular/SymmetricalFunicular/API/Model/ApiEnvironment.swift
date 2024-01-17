//
//  ApiEnvironment.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import Foundation

public enum ApiEnvironment {
    /// A live environment. A real network call will be made by uding the provided network client
    case live
    
    /// A mock environment. Usually no network call is made and a static response is returned.
    case mock
}
