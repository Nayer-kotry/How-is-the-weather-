//
//  HomepageAPIManager.swift
//  How is the weather?
//
//  Created by Nayer Kotry on 06/09/2023.
//

import Foundation
import Alamofire

class HomepageAPIManager {
    
//    func changeToHomePageFormat(weatherAPIData: WeatherAPIFetch, userLocation:Bool) -> CityWeather{
    func changeToHomePageFormat(weatherAPIData: HomepageModel, userLocation:Bool, rawData: Data) -> CityWeather{
    
        var cityName = ""
        var countryName = ""
        var temperature = ""
        var isDay: Bool = true
        var weatherCondition: WeatherCondition = .cloudy
        if let _ = weatherAPIData.location {
            
            if let name = weatherAPIData.location?.name {
                cityName = name
            }
            
//            if let region = weatherAPIData.location?.region {
//                countryName = region
//            }
//
//            if let country = weatherAPIData.location?.country{
//                countryName+=", "+country
//            }
            
            if let country = weatherAPIData.location?.country{
                countryName+=country
            }
            
            if let current = weatherAPIData.current {
                
                if let temp = current.temp_c {
                    
                    temperature = String(Int(temp))
                }
                isDay = current.is_day == 1
                if let condition = current.condition {
                    
                    if let conditionText = condition.text
                    {
                        weatherCondition = WeatherCondition(rawValue: conditionText) ?? .clear
                    }
                }
                
            }
            
            
        }
        return CityWeather(cityName: cityName, countryName: countryName, temperature: temperature, currentWeather: weatherCondition, userLocation: userLocation, isDay: isDay, rawData: rawData)
    }
    
    func homepageCityFetchAPI(with cityName: String, completion: @escaping (Result<Data,Error>)->Void) {
        let API_Key = Constants.API.weatherAPIkey
        let baseURL = Constants.API.baseURL
        let urlString = baseURL + "current.json?q=\(cityName.replacingOccurrences(of: " ", with: "%20"))&key=\(API_Key)"
        let url = URL(string: urlString)
        if let urlCreated = url {
            let urlRequest = URLRequest(url: urlCreated)
            AF.request(urlRequest).validate().responseJSON { [weak self] response in
                guard let self = self else { return }
                do {
                    // Check if there's an error
                    if let error = response.error {
                        throw error
                    }
                    
                    // Check if the response contains data
                    guard let _ = response.data else {
                        throw NSError(domain: "WeatherAPIError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    }
                    if let data = response.data {
                        return completion(.success(data))
                    }
                }
                catch {
                    // Handle the error and call the completion handler with the error
                    completion(.failure(Error.self as! Error))
                }
            }
        }
    }
    
    
}
