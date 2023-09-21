//
//  WeatherStatsCollectionViewCell.swift
//  How is the weather?
//
//  Created by Nayer Kotry on 10/09/2023.
//

import UIKit

class WeatherStatsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var statIcon: UIImageView!
    @IBOutlet weak var statLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var ExtraLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 7
        self.layer.borderColor = UIColor(red: 0.0, green: 00.0, blue: 0.0, alpha: 0.1).cgColor
    }
    
    func config(stat:(String,Any?)) {
        var value  = ""
        if let x = stat.1 as? Float {
            value = "\(Int(x))"
        }
        if let x = stat.1 as? Int {
            value = "\(x)"
        }
        if let x = stat.1 as? String {
            value = x
        }
        valueLabel.text = value
        var image = ""
        ExtraLabel.isHidden = true
        switch(stat.0) {
        case "humidity":
            image = "humidity"
            statLabel.text = "HUMIDITY"
            valueLabel.text = value + "%"
            break
            
        case "precipitation" :
            image = "drop.fill"
            statLabel.text = "PRECIPITATION"
            valueLabel.text = value + "mm"
            break
            
        case "pressure":
            image = "speedometer"
            statLabel.text = "PRESSURE"
            valueLabel.text = value + "mb"
            break
            
        case "wind" :
            ExtraLabel.isHidden = false
            image = "wind"
            print(stat)
            if let x = stat.1 as? (String?,Float?) {
                valueLabel.text = "\(Int(x.1 ?? 0))Km/h"
                ExtraLabel.text = x.0
            }
            statLabel.text = "WIND"
            break
            
        case "feelsLike" :
            image = "thermometer.medium"
            statLabel.text = "FEELS LIKE"
            valueLabel.text = value + "°"
            break
        case "vis" :
            image = "eye.fill"
            statLabel.text = "VISIBILITY"
            valueLabel.text = value + "Km"
        case "cloud" :
            image = "cloud.fill"
            statLabel.text = "CLOUD"
            valueLabel.text = value + "%"
            
        case "uv" :
            ExtraLabel.isHidden = false
            image = "sun.max.fill"
            statLabel.text = "UV INDEX"
            if let uv = stat.1 as? Int {
                switch uv {
                case 1...3: ExtraLabel.text = "LOW"
                case 4...6: ExtraLabel.text = "MODERATE"
                case 7...9: ExtraLabel.text = "HIGH"
                case 10: ExtraLabel.text = "VERY HIGH"
                default:
                    print("uv out of range")
                }
            }
            break
        default:
            image = "Humidity"
        }
        
        statIcon.image = UIImage(systemName: image)
      
           
    }

}
