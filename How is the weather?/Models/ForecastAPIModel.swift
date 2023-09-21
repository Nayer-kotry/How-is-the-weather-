//
//  ForcastAPIData.swift
//  How is the weather?
//
//  Created by Nayer Kotry on 07/09/2023.
//

import Foundation

struct ForecastAPIModel: Codable {
    var forecast: Forecast?
    
    struct Forecast: Codable {
        var forecastday: [ForecastDay]?
    }
    
    struct ForecastDay: Codable {
        
        var date: String?
        var day: Day?
        var astro: Astro?
        var hour: [Hour]?
        
        
    }
    
    struct Day: Codable {
        var maxtemp_c: Double?
        var maxtemp_f: Double?
        var mintemp_c: Double?
        var mintemp_f: Double?
        var avgtemp_c: Double?
        var avgtemp_f: Double?
        var maxwind_mph: Double?
        var maxwind_kph: Double?
        var totalprecip_mm: Double?
        var totalprecip_in:Double?
        var totalsnow_cm: Double?
        var avgvis_km: Double?
        var avgvis_miles: Double?
        var avghumidity: Double?
        var daily_will_it_rain: Int?
        var daily_chance_of_rain: Int?
        var daily_will_it_snow: Int?
        var daily_chance_of_snow: Int?
        var condition: Condition?
        var uv: Int?
    }
    
    struct Astro: Codable {
        let sunrise: String?
        let sunset: String?
        let moonrise: String?
        let moonset: String?
        let moon_phase: String?
        let moon_illumination: String?
        let is_moon_up: Int?
        let is_sun_up: Int?
    }
    
    struct Hour: Codable {
        
        let time: String?
        let temp_c: Double?
        let temp_f: Double?
        let is_day: Int?
        let condition: Condition?
        let wind_mph: Double?
        let wind_kph: Double?
        let wind_degree: Int?
        let wind_dir: String?
        let pressure_mb: Double?
        let pressure_in: Double?
        let precip_mm: Double?
        let precip_in: Double?
        let humidity: Int?
        let cloud: Int?
        let feelslike_c: Double?
        let feelslike_f: Double?
        let windchill_c: Double?
        let windchill_f: Double?
        let heatindex_c: Double?
        let heatindex_f: Double?
        let dewpoint_c: Double?
        let dewpoint_f: Double?
        let will_it_rain: Int?
        let chance_of_rain: Int?
        let will_it_snow: Int?
        let chance_of_snow: Int?
        let vis_km: Double?
        let vis_miles: Double?
        let gust_mph: Double?
        let gust_kph: Double?
        let uv: Double?
    }
    
    struct Condition: Codable{
        let text: String?
        let icon: String?
        let code: Int?
    }
}

      
         

