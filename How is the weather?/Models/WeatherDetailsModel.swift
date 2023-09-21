//
//  WeatherDetailsModel.swift
//  How is the weather?
//
//  Created by Nayer Kotry on 07/09/2023.
//

import Foundation

struct WeatherDetails {
    
    struct CityDitails {
        var cityName: String?
        var countryName: String?
        var locationTime: String?
        var isDay: Bool?
        var userLocation: Bool?
    }
    
    struct DayWeather{
        var weatherStats: WeatherStats
        var DayHigh: Double?
        var DayLow:  Double?
    }
 
    var cityDitails: CityDitails
    var dayWeather: DayWeather
    var hourlyWeather: [HourlyCellData]
    var dailyWeather: [DailyCellData]
}


struct WeatherStats{
    var currentWeather: WeatherCondition
    var temperature: Float?
    var humidity: Int?
    var precipitation:Float?
    var pressure: Float?
    var windSpeed: Float?
    var feelsLike: Float?
    var uv: Int?
    var windDir: String?
    var windAngle: Int?
    var cloud: Int?
    var vis: Float?
    var statsArr: [(String, Any?)]  {
        return [ ("humidity", humidity),  ("precipitation", precipitation),  ("pressure", pressure),  ("wind", (windDir,windSpeed)),  ("feelsLike", feelsLike), ("uv", uv),("cloud", cloud),("vis", vis)]
    }
 
}

struct DailyCellData {
    var day: String
    var icon: WeatherCondition
    var DayHigh: String
    var DayLow: String
}
