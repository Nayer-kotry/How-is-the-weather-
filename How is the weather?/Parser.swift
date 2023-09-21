//
//  Parser.swift
//  How is the weather?
//
//  Created by Nayer Kotry on 19/09/2023.
//

import Foundation

class Parser<T: Codable> {
    func parseJSON(data: Data, model: T.Type) -> T?{
//        parse()
        let decoder = JSONDecoder()
        do{
            let parsed = try decoder.decode(model.self, from: data)
            return parsed
        }
        catch{
            print(error)
            return nil
        }
    }
}
