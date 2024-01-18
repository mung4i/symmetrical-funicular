//
//  JSONDecoder+.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import Foundation

extension Repository {
    static func loadFromURL(filename name: String) -> Repositories? {
        if let url = Bundle.main.url(forResource: name, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                return try decoder.decode(Repositories.self, from: data)
            } 
            catch {
                return nil
            }
        }
        return nil
    }
}
