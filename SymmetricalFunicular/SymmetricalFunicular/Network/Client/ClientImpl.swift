//
//  ClientImpl.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import Foundation

struct NetworkClientImpl: NetworkClient {
    
    // MARK: - Properties
    
    public var dump: Bool = true
    
    private let urlSession: URLSession
    private let environment: Environment
    
    private let responseMock = ResponsesMock()
    
    // MARK: - Initializers
    
    public init(
        urlSession: URLSession = URLSession.shared,
        environment: Environment = EnvironmentLive()
    ) {
        self.environment = environment
        self.urlSession = urlSession
    }
    
    // MARK: - Protocol Methods
    
    public func get<T>(
        endpoint: String,
        headers: HTTPHeaders,
        expecting type: T.Type,
        queryParameters: [String : String]?
    ) async -> Result<T, NetworkError> where T : Decodable {
        
        await request(
            endpoint: endpoint,
            method: .get,
            headers: headers,
            expecting: type,
            queryParameters: queryParameters
        )
    }
    
    public func post<T: Decodable>(
        endpoint: String,
        headers: HTTPHeaders,
        body: Data?,
        expecting type: T.Type,
        queryParameters: [String: String]?
    ) async -> Result<T, NetworkError> {
        
        await request(
            endpoint: endpoint,
            method: .post,
            headers: headers,
            body: body,
            expecting: type,
            queryParameters: queryParameters
        )
    }
    
    // MARK: - Helper Methods
    
    public func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        body: Data? = nil,
        expecting type: T.Type,
        queryParameters: [String: String]?
    ) async -> Result<T, NetworkError> {
        
        do {
            let urlString = environment.baseURL + endpoint
            
            guard var urlComponents = URLComponents(string: urlString) else {
                return .failure(.invalidURL)
            }
            
            let queryItems = queryParameters?.compactMap { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            
            urlComponents.queryItems = queryItems
            
            guard let url = urlComponents.url else {
                return .failure(NetworkError.invalidURL)
            }
            
            return await performRequest(
                url: url,
                method: method,
                headers: headers,
                body: body,
                expecting: type)
        }
    }
    
    private func performRequest<T: Decodable>(
        url: URL,
        method: HTTPMethod,
        headers: HTTPHeaders,
        body: Data? = nil,
        expecting type: T.Type
    ) async -> Result<T, NetworkError> {
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            headers.forEach { headerField, value in
                request.addValue(value, forHTTPHeaderField: headerField)
            }
            request.httpBody = body
            
            let (data, response) = try await urlSession.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(NetworkError.invalidResponse)
            }
            
            if dump {
                print("\n\(request.getCurlString(hideToken: false))\n")
            }
            
            guard httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 else {
                return .failure(NetworkError.fail(data, httpResponse))
            }
            
            if type == String.self && data.count == 0 {
                return .success("" as! T)
            }
            
            let object = try JSONDecoder().decode(type, from: data)
            return .success(object)
        }
        
        catch {
            if error is DecodingError {
                return .failure(.invalidData)
            }
            
            return .failure(.other(error))
        }
    }
}
