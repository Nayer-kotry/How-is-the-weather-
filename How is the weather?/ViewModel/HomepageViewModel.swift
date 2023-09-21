//
//  HomepageViewModel.swift
//  How is the weather?
//
//  Created by Nayer Kotry on 05/09/2023.
//

import Foundation
import UIKit
import Alamofire

class HomepageViewModel {
    
    private var cities: [CityWeather] = []
    private var userCity: CityWeather? = nil
    private var userCityUnformatted: WeatherAPIFetch? = nil
    
    private var unformatedCity: WeatherAPIFetch? = nil
    private var unformatedcities: [WeatherAPIFetch] = []
    
    func getAllCities() -> [CityWeather] {
        return cities
    }
    
    func setAllCities(cities: [CityWeather]){
        self.cities = cities
    }
    func appendCityFirst(city: CityWeather){
        self.cities.insert(city, at: 0)
        
    }
    func appendCityLast(city: CityWeather){
        self.cities.append(city)
    }
    
    
    func getCitiesCount() -> Int {
        return cities.count
    }
    
    func setUserCity(with city: CityWeather) {
        userCity = city
    }
    
    func getUserCity() ->  CityWeather? {
        return userCity
    }
    
    func setUserCtyUnformatted(with city: WeatherAPIFetch) {
        userCityUnformatted = city
    }
    
    func getUserUnformattedCity() ->  WeatherAPIFetch? {
        return userCityUnformatted
    }
    
    func getCity(at index: Int) -> CityWeather? {
        
        if index >= 0 && index < cities.count && !cities.isEmpty {
            return cities[index]
            
        }
        return nil
    }
    
    func removeCity(at index: Int) {
        if index >= 0 && index < cities.count && !cities.isEmpty {
            cities.remove(at: index)
            
        }
    }
    
    func setSelectedCityUnformatted(with city: WeatherAPIFetch) {
        unformatedCity = city
    }
    
    func getSelectedCityUnformatted() -> WeatherAPIFetch? {
        return unformatedCity
    }
    func getAllUnformatedCities() -> [WeatherAPIFetch] {
        return unformatedcities
    }
    
    func setAllUnformatedCities(cities: [WeatherAPIFetch]){
        self.unformatedcities = cities
    }
    func appendUnformatedCityFirst(city: WeatherAPIFetch){
        self.unformatedcities.insert(city, at: 0)
        
    }
    func appendUnformatedCityLast(city: WeatherAPIFetch){
        self.unformatedcities.append(city)
    }
    
    func getUnformatedCity(at index: Int) -> WeatherAPIFetch? {
        
        if index < unformatedcities.count && !unformatedcities.isEmpty {
            return unformatedcities[index]
            
        }
        return nil
    }
    
    func removeUnformatedCity(at index: Int) {
        if index >= 0 && index < unformatedcities.count && !unformatedcities.isEmpty {
            unformatedcities.remove(at: index)
            
        }
    }
    
    func fetchCities(cities: [String], completion: @escaping ((Result<[CityWeather]?, Error>) -> Void)) {
        
        var cityWeatherArray: [CityWeather] = []
        let group = DispatchGroup()
        for city in cities {
            group.enter()
            fetchCityWeather(city: city) { Result in
                defer {
                    group.leave()
                }
                switch(Result){
                case .success(let cityWeather):
                    if let weather = cityWeather {
                        cityWeatherArray.append(weather)
                    }
                case .failure(let err):
                    completion(.failure(err))
                    return
                }
            }
        }
        
        group.notify(qos: .userInitiated, queue: DispatchQueue.global()) { [weak self] in
            guard let self = self else { return }
            self.setAllCities(cities: cityWeatherArray)
            self.setAllUnformatedCities(cities: self.unformatedcities)
            completion(.success(cityWeatherArray))
        }
    }
    
    func fetchCityWeather(city: String, userLocation: Bool = false, completion: ( (Result<CityWeather?,Error>)-> Void)? = nil) {
        
        //TODO: Create Constants file
        
        let HomepageAPIManager = HomepageAPIManager()
        HomepageAPIManager.homepageCityFetchAPI(with: city){ result in
            switch(result){
            case .success(let city):
                let parser = Parser<HomepageModel>()
                let parsedData = parser.parseJSON(data: city, model: HomepageModel.self)
                if let parsed = parsedData {
                    let formatedData = HomepageAPIManager.changeToHomePageFormat(weatherAPIData: parsed, userLocation: userLocation, rawData: city)
                    completion?(.success(formatedData))
                }
               
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
//                    if let data = response.data {
//                        if let res: WeatherAPIFetch = self.parseJSON(data: data, model: WeatherAPIFetch.self) {
//
//                            let formatedRes = HomepageAPIManager.changeToHomePageFormat(weatherAPIData: res, userLocation: userLocation)
//                            completion?(formatedRes, res,nil)
//                        }
//                    }
            
