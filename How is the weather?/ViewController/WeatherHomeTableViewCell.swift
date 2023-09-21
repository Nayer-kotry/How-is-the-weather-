//
//  weatherHomeTableViewCell.swift
//  How is the weather?
//
//  Created by Nayer Kotry on 03/09/2023.
//

import UIKit

class WeatherHomeTableViewCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var yourLoc: UIView!
    
    // MARK: Variables
    
    //MARK: lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.clipsToBounds = true
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: functions
    
    func configNib(cityWeather: CityWeather) {
        DispatchQueue.global().async {
            let image = UIImage(named: cityWeather.currentWeather.imageRepresentation(isDay: cityWeather.isDay))
            DispatchQueue.main.async {
                self.weatherImage.image = image
            }
           
        }
        
        cityLabel.text = cityWeather.cityName
        countryLabel.text = cityWeather.countryName
        temperatureLabel.text = cityWeather.temperature
        if cityWeather.userLocation {
            yourLoc.isHidden = false
        }
        else {
            yourLoc.isHidden = true
        }
           
    }
    
    
    
}
