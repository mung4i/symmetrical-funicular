//
//  ResponsesMock.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import Foundation

public class ResponsesMock {
    
    public var runAfterMockedErrorResponseForEndpoint: ((String) -> Void)?
    public var runAfterMockedResponseForEndpoint: ((String) -> Void)?
    
    private var mockedErrorResponse: [String: HTTPURLResponse] = [:]
    private var mockedErrorData: [String: Data] = [:]
    
    private var mockedResponse: [String: Any] = [:]
    
    init() {}
    
    public func setMockedErrorResponseFor(_ endpoint: String, data: Data?, response: HTTPURLResponse?)  {
        mockedErrorResponse[endpoint] = response
        mockedErrorData[endpoint] = data
    }
    
    public func setMockedResponseFor<T: Decodable>(_ endpoint: String, response: T?)  {
        mockedResponse[endpoint] = response
    }
    
    public func removeMockedResponseFor(_ endpoint: String) {
        mockedErrorData.removeValue(forKey: endpoint)
        mockedErrorResponse.removeValue(forKey: endpoint)
        mockedResponse.removeValue(forKey: endpoint)
    }
    
    public func mockedResponseFor<T: Decodable>(_ endpoint: String) -> T? {
        let response = mockedResponse[endpoint] as? T
        if response != nil {
            runAfterMockedResponseForEndpoint?(endpoint)
        }
        return response
    }
    
    public func mockedErrorResponseFor(_ endpoint: String) -> (Data?, HTTPURLResponse?) {
        let response = mockedErrorResponse[endpoint]
        let data = mockedErrorData[endpoint]
        if response != nil || data != nil {
            runAfterMockedErrorResponseForEndpoint?(endpoint)
        }
        return (data, response)
    }
}
