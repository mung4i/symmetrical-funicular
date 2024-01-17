//
//  Environment.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import Foundation

protocol Environment {
    
    /// The base url to access the backend application.
    var baseURL: String { get }
    
    /// User defaults instance for local key / value storage.
    var userDefaults: UserDefaults { get set }
    
    /// A function to return a backend environment.
    /// - Returns: The environment name.
    func getEnvironment() -> String
    
    /// A function to set the current environment for the app.
    /// - Parameter environment: The environment name.
    func setEnvironment(_ environment: String)
}

struct EnvironmentLive: Environment {
    init() {}
    var baseURL: String {
        getEnvironment()
    }
    
    var userDefaults: UserDefaults = .standard
}

private extension String {
    static let selectedEnvironment = "selectedEnvironment"
}

extension Environment {
    
    public func getEnvironment() -> String {
        "https://api.github.com"
    }
    
    public func setEnvironment(_ environment: String) {
        userDefaults.set(environment, forKey: .selectedEnvironment)
    }
}
