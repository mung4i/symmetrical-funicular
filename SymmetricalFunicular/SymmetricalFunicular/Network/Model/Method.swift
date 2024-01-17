//
//  Method.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//
import Foundation

// MARK: - HTTP Headers

public typealias HTTPHeaders = [String: String]

// MARK: - HTTP Methods

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}
