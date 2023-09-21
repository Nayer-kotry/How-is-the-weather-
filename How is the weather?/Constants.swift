//
//  constants file.swift
//  How is the weather?
//
//  Created by Nayer Kotry on 06/09/2023.
//

import Foundation

struct Constants {
    static let defaultCities = ["London", "New York", "Paris", "Berlin"]
    
    struct API{
        static let weatherAPIkey = "461e29581a5e4ea68f3143601230309"
        static let baseURL = "https://api.weatherapi.com/v1/"
    }
    struct Homepage{
        
        struct TableView {
            static let nibName = "WeatherHomeTableViewCell"
            static let identifier = "WeatherHomeTableViewCell"
        }
        struct segues {
            static let homeToDetails = "homeToDetailsSegue"
        }
        
    }
 
}
