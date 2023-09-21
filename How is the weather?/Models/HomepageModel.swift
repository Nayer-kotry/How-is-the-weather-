//
//  homepageModel.swift
//  How is the weather?
//
//  Created by Nayer Kotry on 19/09/2023.
//

import Foundation

//
//  WeatherDetailsModel.swift
//  How is the weather?
//
//  Created by Nayer Kotry on 07/09/2023.
//

import Foundation

struct HomepageModel: Codable {
    
    let location: Location?
    let current: Current?
    
    //CodingKeys
    
    struct Location: Codable
    {
        let name: String?
        let region: String?
        let country: String?
    }
    
    struct Current: Codable {
        let temp_c: Float?
        let is_day: Int?
        let condition: Condition?
    }
    
    struct Condition: Codable{
        let text: String?
    }

}
