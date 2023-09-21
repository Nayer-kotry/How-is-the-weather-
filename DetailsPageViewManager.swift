//
//  DetailsPageViewManager.swift
//  How is the weather?
//
//  Created by Nayer Kotry on 07/09/2023.
//
import Foundation

//protocol Parser {
//    func parse()
//}
//
//extension Parser {
//    func parse(){
//        print("hi")
//    }
//}

//class DetailsPageViewManager: Parser {

class DetailsPageViewManager {
        
    func parseJSON<T: Codable>(data: Data, model: T.Type) -> T?{
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
    
    func formatDataToDetailsPage(currentWeatherData: WeatherAPIFetch, forecastWeatherData: ForecastAPIModel, userLocation: Bool) -> WeatherDetails {
        let cityName = currentWeatherData.location?.name
        let countryName = currentWeatherData.location?.country
        let locationTime = currentWeatherData.location?.localtime
        let isDay = currentWeatherData.current?.is_day == 1
    
        let cityDitails = WeatherDetails.CityDitails(cityName: cityName, countryName: countryName, locationTime: locationTime, isDay: isDay, userLocation: userLocation)
        
        var weatherCondition: WeatherCondition = .clear
        if let conditionText = currentWeatherData.current?.condition?.text
        {
            weatherCondition = WeatherCondition(rawValue: conditionText) ?? .clear
        }

      
        let temperature = currentWeatherData.current?.temp_c
        let humidity = currentWeatherData.current?.humidity
        let precipitation = currentWeatherData.current?.precip_mm
        let pressure = currentWeatherData.current?.pressure_mb
        let windSpeed = currentWeatherData.current?.wind_kph
        let feelsLike = currentWeatherData.current?.feelslike_c
        let uv = currentWeatherData.current?.uv
        let windDir = currentWeatherData.current?.wind_dir
        let windAngle = currentWeatherData.current?.wind_degree
        let cloud = currentWeatherData.current?.cloud
        let vis = currentWeatherData.current?.vis_km
        
        let weatherStats = WeatherStats(currentWeather: weatherCondition, temperature: temperature, humidity: humidity, precipitation: precipitation, pressure: pressure, windSpeed: windSpeed, feelsLike: feelsLike, uv: uv, windDir: windDir, windAngle: windAngle, cloud: cloud, vis: vis)
        
        var dayHigh: Double?
        var dayLow: Double?
        var hours: [HourlyCellData] = []
        var forcastDays: [DailyCellData] = []
        if let days = forecastWeatherData.forecast?.forecastday {
            if days.count > 0 {
                if let todaysDetails = days[0].day {
                    dayHigh = todaysDetails.maxtemp_c
                    dayLow = todaysDetails.mintemp_c
                    
                }
                
                for (index, day) in days.enumerated() {
                    var weatherCondition : WeatherCondition = .cloudy
                    if let conditionText = day.day?.condition?.text
                    {
                        weatherCondition = WeatherCondition(rawValue: conditionText) ?? .clear
                    }
                    var date = "x"
                    if let d = day.date {
                        if index == 0 {
                        date = "Today"
                        }
                        else {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            if let dateObject = dateFormatter.date(from: d) {
                                let dayNameFormatter = DateFormatter()
                                dayNameFormatter.dateFormat = "EEEE"
                                date = dayNameFormatter.string(from: dateObject)
                            }
                        }
                    }
                    
                    forcastDays.append(DailyCellData(day: date, icon: weatherCondition, DayHigh: "\(Int(day.day?.maxtemp_c ?? -100))°", DayLow: "\(Int(day.day?.mintemp_c ?? -100))°"))
                }
                
                var now = false
                var count = 0
                let currentDate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd H:mm"
                let currentDateString = dateFormatter.string(from: currentDate)
                let LocalTime = dateFormatter.date(from: currentWeatherData.location?.localtime ?? currentDateString) ?? currentDate
                let prevHour = Calendar.current.date(byAdding: .hour, value: -1, to: LocalTime)!
                var NhoursAdded = 0
              
                for day in days {
                    if let hrs = day.hour {
                        var weatherCondition: WeatherCondition = .cloudy
                        if hrs.count > 0 {
                            var prevDate: Date?
                            for hr in hrs {
                                
                                var time = "-2"
                                var  timeDate: Date?
                                if let dateString = hr.time{
                                    
                                    dateFormatter.dateFormat = "yyyy-MM-dd H:mm"
                                    if let date = dateFormatter.date(from: dateString) {
                                        timeDate = date
                                        if(date<prevHour){
                                            continue
                                        }
                                        count+=1
                                        if (count == 1){
                                            now = true
                                        }
                                        let timeFormatter = DateFormatter()
                                        timeFormatter.dateFormat = "h a" // Format to "8 AM" or "8 PM"
                                        time = timeFormatter.string(from: date).replacingOccurrences(of: " ", with: "")
                                    }
                                }
                                if let condition = hr.condition {
                                    if let conditionText = condition.text
                                    {
                                        weatherCondition = WeatherCondition(rawValue: conditionText) ?? .clear
                                    }
                                }
                                if(now) {
                                    time = "Now"
                                    now = false
                                }
                      
                                if NhoursAdded<24 {
                                    NhoursAdded += 1
                                    if let date = day.date {
                                        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
                                        if let sunrise = day.astro?.sunrise {
                                            let sunriseDate = dateFormatter.date(from: ("\(date) \(sunrise)"))
                                            if timeDate != nil && sunriseDate != nil{
                                                dateFormatter.dateFormat = "h:mm a"
                                                if (prevDate != nil) {
                                                    if(sunriseDate! > prevDate! && sunriseDate! < timeDate!){
                                                        let sunriseStr = dateFormatter.string(from: sunriseDate!)
                                                        hours.append(HourlyCellData(time: sunriseStr, icon: WeatherCondition(rawValue: "sunrise")  ?? .clear, temp: "\(Int(hr.temp_c ?? -100))°", isDay: hr.is_day == 1))
                                                    }
                                                }
                                                
                                            }
                                        }
                                        
                                        if let sunset = day.astro?.sunset {
                                            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
                                            let sunsetDate = dateFormatter.date(from: ("\(date) \(sunset)"))
                                            if timeDate != nil && sunsetDate != nil{
                                                dateFormatter.dateFormat = "h:mm a"
                                                
                                                if (prevDate != nil) {
                                                    if(sunsetDate! > prevDate! && sunsetDate! < timeDate!){
                                                        let sunsetStr = dateFormatter.string(from: sunsetDate!)
                                                        hours.append(HourlyCellData(time: sunsetStr, icon: WeatherCondition(rawValue: "sunset")  ?? .clear, temp: "\(Int(hr.temp_c ?? -100))°", isDay: hr.is_day == 1))
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                    hours.append(HourlyCellData(time:time, icon: weatherCondition, temp: "\(Int(hr.temp_c ?? -100))°", isDay: hr.is_day == 1))
                                    prevDate = timeDate
                                }
                                else {
                                    break
                                }
                               
                            }
                        }
                       
                    }
                }
        
                
                
            }
           
        }
        

        if let today = forecastWeatherData.forecast?.forecastday?[0] {
            dayLow = today.day?.mintemp_c
        }
        
        let dayWeather = WeatherDetails.DayWeather(weatherStats: weatherStats, DayHigh: dayHigh, DayLow: dayLow)
        
  
        
    
        return WeatherDetails(cityDitails: cityDitails, dayWeather: dayWeather, hourlyWeather: hours, dailyWeather: forcastDays)
        
    }
}
