//
//  HomepageCityWeatherModel.swift
//  How is the weather?
//
//  Created by Nayer Kotry on 04/09/2023.
//

import Foundation

struct CityWeather {
    
    var cityName: String
    var countryName: String
    var temperature: String
    var currentWeather: WeatherCondition
    var userLocation: Bool
    var isDay: Bool
    var rawData: Data
    
    init(cityName: String, countryName: String, temperature: String, currentWeather: WeatherCondition, userLocation: Bool = false, isDay: Bool, rawData: Data) {
        self.cityName = cityName
        self.countryName = countryName
        self.temperature = temperature
        self.currentWeather = currentWeather
        self.userLocation = userLocation
        self.isDay = isDay
        self.rawData = rawData
    }
}

struct CityHomeDTO {
    
    var cityName: String
    
    
    init(city: CityWeather) {
        self.cityName = city.cityName
    }
    
}
