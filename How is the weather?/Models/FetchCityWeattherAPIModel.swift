//
//  FetchCityWeattherAPIModel.swift
//  How is the weather?
//
//  Created by Nayer Kotry on 05/09/2023.
//

import Foundation

struct WeatherAPIFetch: Codable {
    
    let location: Location?
    let current: Current?
    
    //CodingKeys
    
    struct Location: Codable
    {
        let name: String?
        let region: String?
        let country: String?
        let lat: Float?
        let lon: Float?
        let tz_id: String?
        let localtime_epoch: Int?
        let localtime: String?
        
    }
    
    struct Current: Codable{
        let last_updated_epoch: Int?
        let last_updated: String?
        let temp_c: Float?
        let temp_f: Float?
        let is_day: Int?
        let condition: Condition?
        let wind_mph: Float?
        let wind_kph: Float?
        let wind_degree: Int?
        let wind_dir: String?
        let pressure_mb: Float?
        let pressure_in: Float?
        let precip_mm: Float?
        let precip_in: Float?
        let humidity: Int?
        let cloud: Int?
        let feelslike_c: Float?
        let feelslike_f: Float?
        let vis_km: Float?
        let vis_miles: Float?
        let uv: Int?
        let gust_mph: Float?
        let gust_kph: Float?
        let air_quality: Air_quality?
        
        
    }
    
    struct Condition: Codable{
        let text: String?
        let icon: String?
        let code: Int?
    }
    
    struct Air_quality: Codable {
        
        let co: Float?
        let no2: Float?
        let o3: Float?
        let so2: Float?
        let pm2_5: Float?
        let pm10: Int?
        
    }
}

