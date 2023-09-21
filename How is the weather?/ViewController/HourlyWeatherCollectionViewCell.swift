//
//  hourlyWeatherCollectionViewCell.swift
//  How is the weather?
//
//  Created by Nayer Kotry on 07/09/2023.
//

import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeInHoursLabel: UILabel!
    @IBOutlet weak var tempAtThisHourLabel: UILabel!
    @IBOutlet weak var weatherIconUIImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func configNib(with cell: HourlyCellData) {
        weatherIconUIImage.image = UIImage(systemName: cell.icon.getWeatherIcon(isDay: cell.isDay) ?? "moon.stars.fill")
        timeInHoursLabel.text = cell.time
        tempAtThisHourLabel.text = cell.temp
    }
}
