//
//  WeattherDetailsViewModel.swift
//  How is the weather?
//
//  Created by Nayer Kotry on 07/09/2023.
//


import UIKit
import Alamofire

class WeatherDetailsViewModel {
    
    private var hourlyData: [HourlyCellData] = []
    
    private var dailyData: [DailyCellData] =  []
    
    private var weatherDetails: WeatherDetails?
 
    
    func getWeatherDetails() -> WeatherDetails? {
        return weatherDetails
    }
    func setWeatherDetails( weather: WeatherDetails) {
         weatherDetails = weather
    }
    func getDailyData() -> [DailyCellData] {
        return dailyData
    }
    
    func setDailyData(with data: [DailyCellData]) {
        dailyData = data
    }
    
    func getDailyDataCount() -> Int {
        return dailyData.count
    }
    
    func getDailyData(at index: Int) -> DailyCellData? {
        if index >= 0 && index < dailyData.count && !dailyData.isEmpty {
            return dailyData[index]
        }
        return nil
    }
    
    func getHourlyData() -> [HourlyCellData] {
        return hourlyData
    }
    
    func setHourlyData(with data: [HourlyCellData]) {
        hourlyData = data
    }
    
    func getHourlyDataCount() -> Int {
        return hourlyData.count
    }
    
    func getHourlyData(at index: Int) -> HourlyCellData? {
        if index >= 0 && index < hourlyData.count && !hourlyData.isEmpty {
            return hourlyData[index]
        }
        return nil
    }
    
    
    func fetchCityForecast(city: String,  completion: ( (ForecastAPIModel?, Error?)-> Void)? = nil) {
        
        //TODO: Create Constants file
        
        let API_Key = Constants.API.weatherAPIkey
        let baseURL = Constants.API.baseURL
        let urlString =  baseURL+"forecast.json?q=\(city.replacingOccurrences(of: " ", with: "%20"))&days=3&key=\(API_Key)"
        
        
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
                        let detailsPageViewManager = DetailsPageViewManager()
                        //TODO: should I place the parse function in the model class or manager or as a seperate file
                        if let res: ForecastAPIModel = detailsPageViewManager.parseJSON(data: data, model: ForecastAPIModel.self) {
                            completion?(res, nil)
                        }
                    }
                }
                catch {
                    completion?(nil, error)
                }
            }
           
        }
    }
    
    func getDetails(cityName: String, rawData: Data, userLoc:Bool = false, completion: ( (WeatherDetails?, Error?)-> Void)? = nil) {
        
        fetchCityForecast(city: cityName) {[weak self] data,error in
            guard let self = self else {return}
            if let _ = error {
                completion?(nil, error)
                return
            }
            let detailsPageViewManager = DetailsPageViewManager()
            if data != nil {
                let parser = Parser<WeatherAPIFetch>()
                let homepageAllData = parser.parseJSON(data: rawData, model: WeatherAPIFetch.self)
                if let home = homepageAllData {
                    let formatedRes = detailsPageViewManager.formatDataToDetailsPage(currentWeatherData: home, forecastWeatherData: data!, userLocation: userLoc)
                    self.setDailyData(with: formatedRes.dailyWeather)
                    self.setHourlyData(with: formatedRes.hourlyWeather)
                    self.setWeatherDetails(weather: formatedRes)
                    completion?(formatedRes,nil)
                }
            
     
            }
          
        }
    }
    
}
