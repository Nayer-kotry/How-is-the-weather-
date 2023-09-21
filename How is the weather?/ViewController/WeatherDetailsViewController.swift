//
//  WeatherDetailsViewController.swift
//  How is the weather?
//
//  Created by Nayer Kotry on 06/09/2023.
//


import UIKit

class WeatherDetailsViewController: UIViewController {
    
    //MARK: outlet
    @IBOutlet weak var regionBorderView: UIView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var dailyLowTempLabel: UILabel!
    @IBOutlet weak var dailyHighTempLabel: UILabel!
    @IBOutlet weak var BackgroundUIImage: UIImageView!
    @IBOutlet weak var weatherIconKeyword: UILabel!
    @IBOutlet weak var weatherIconKeywordBorderView: UIView!
    @IBOutlet weak var forcastLabelBorderView: UIView!
    @IBOutlet weak var weatherKeyword: UILabel!
    @IBOutlet weak var hourlyForecastCollectionView: UICollectionView!
    @IBOutlet weak var statsCollectionView: UICollectionView!

    @IBOutlet weak var statsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dailyForecastTableView: UITableView!
    
    @IBOutlet weak var locationIcon: UIImageView!
    //MARK: variables
    var homeData: CityWeather? = nil
    var weatherDetailsViewModel: WeatherDetailsViewModel!
    var currentWeatherAPIData: WeatherAPIFetch? = nil
    var userLoc: Bool = false
    //MARK: view lifecycle
    override func viewDidLoad() {
        weatherDetailsViewModel = WeatherDetailsViewModel()
        hourlyForecastCollectionView.dataSource = self
        hourlyForecastCollectionView.delegate = self
        hourlyForecastCollectionView.register(UINib(nibName: "HourlyWeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HourlyForcastIdentifier")
        statsCollectionView.dataSource = self
        statsCollectionView.delegate = self
        statsCollectionView.register(UINib(nibName: "WeatherStatsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StatsCollectionViewCell")
        dailyForecastTableView.dataSource = self
        dailyForecastTableView.delegate = self
        dailyForecastTableView.register(UINib(nibName: "DailyForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "DailyIIdentifier")
        styleAllViewBorders()
       
        if let home = homeData {
            weatherDetailsViewModel.getDetails(cityName: home.cityName, rawData:home.rawData, userLoc: userLoc) { [weak self] data, error in
                DispatchQueue.main.async {
                    self?.config()
                    self?.dailyForecastTableView.reloadData()
                    self?.hourlyForecastCollectionView.reloadData()
                    self?.statsCollectionView.reloadData()
                }

            }
        }
        
        
    }
    
    //MARK: functions
    
    func styleAllViewBorders() {
        // adding borders and corner radius to country Name view
         regionBorderView.layer.borderWidth = 3
         regionBorderView.layer.cornerRadius = 8
         regionBorderView.layer.borderColor = UIColor.black.cgColor
         regionBorderView.layer.masksToBounds = true
         
         // adding borders and corner radius to main weather icon
         weatherIconKeywordBorderView.layer.borderWidth = 2
         weatherIconKeywordBorderView.layer.cornerRadius = 8
         weatherIconKeywordBorderView.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1).cgColor
         
         // adding borders and corner radius to "3 day forcast" label
         forcastLabelBorderView.layer.borderWidth = 2
         forcastLabelBorderView.layer.cornerRadius = 7
         forcastLabelBorderView.layer.borderColor = forcastLabelBorderView.tintColor?.cgColor
    
        hourlyForecastCollectionView.layer.borderWidth = 1
        hourlyForecastCollectionView.layer.cornerRadius = 7
        hourlyForecastCollectionView.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1).cgColor
        
        dailyForecastTableView.layer.borderWidth = 1
        dailyForecastTableView.layer.cornerRadius = 7
        dailyForecastTableView.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1).cgColor
      
        
        
    }
    
    func  config() {
        let nColumns = 2
        let width = (statsCollectionView.frame.size.width - CGFloat(nColumns - 1)*10) / CGFloat(nColumns)
        let layout = statsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        statsHeightConstraint.constant = width*4 + 30
        print(layout.itemSize)
        
        let weatherDetails = weatherDetailsViewModel.getWeatherDetails()
        let isDay = weatherDetails?.cityDitails.isDay ?? true
        if let img = homeData?.currentWeather {
            DispatchQueue.global().async {
                let image = UIImage(named: img.portraitImageRepresentation(isDay: isDay))
                DispatchQueue.main.async {
                    self.BackgroundUIImage.image = image
                }
               
            }
        }
        if let currentWeather = weatherDetails?.dayWeather.weatherStats.currentWeather {
            let isDay = weatherDetails?.cityDitails.isDay ?? true
            weatherIconKeyword.text = currentWeather.rawValue
            weatherIconImageView.image = UIImage(systemName: currentWeather.getWeatherIcon(isDay: isDay) ?? "cloudy.fill")
        }
        regionLabel.text = "\(homeData?.cityName ?? ""), \(homeData?.countryName ?? "")"
        currentTempLabel.text = homeData?.temperature
      
    
        if let high = weatherDetails?.dayWeather.DayHigh {
            dailyHighTempLabel.text = "H:\(Int(high))°"
        }
        if let low = weatherDetails?.dayWeather.DayLow {
            dailyLowTempLabel.text = "L:\(Int(low))°"
        }
        if let loc = weatherDetails?.cityDitails.userLocation {
            if loc {
                locationIcon.isHidden = false
            }
            else {
                locationIcon.isHidden = true
            }
        
        }
        else {
            locationIcon.isHidden = true
        }
        
        
        
        
    }
}
//MARK: collectionView class extension

extension WeatherDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hourlyForecastCollectionView {
            print(weatherDetailsViewModel.getHourlyDataCount())
            return weatherDetailsViewModel.getHourlyDataCount()
        }
        else {
            if let arr = weatherDetailsViewModel.getWeatherDetails()?.dayWeather.weatherStats.statsArr {
                return arr.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hourlyForecastCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyForcastIdentifier", for: indexPath) as! HourlyWeatherCollectionViewCell
            cell.configNib(with: weatherDetailsViewModel.getHourlyData(at: indexPath.row)!)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatsCollectionViewCell", for: indexPath) as! WeatherStatsCollectionViewCell
            if let weatherStat = weatherDetailsViewModel.getWeatherDetails()?.dayWeather.weatherStats {
                print( weatherStat.statsArr[indexPath.row])
                cell.config(stat: weatherStat.statsArr[indexPath.row])
            }
            return cell
        }
    }
    
}

//MARK: tableVew class extension

extension WeatherDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherDetailsViewModel.getDailyDataCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyIIdentifier", for: indexPath) as! DailyForecastTableViewCell
        cell.configNib(with: weatherDetailsViewModel.getDailyData(at: indexPath.row)!)
        return cell
        
    }
    
    
}

