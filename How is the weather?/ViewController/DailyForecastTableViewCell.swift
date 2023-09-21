//
//  DailyForecastTableViewCell.swift
//  How is the weather?
//
//  Created by Nayer Kotry on 07/09/2023.
//

import UIKit

class DailyForecastTableViewCell: UITableViewCell {

   
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    
    @IBOutlet weak var dayLowLabel: UILabel!
 
    @IBOutlet weak var dayHighLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configNib(with cell: DailyCellData) {
        weatherIcon.image = UIImage(systemName:cell.icon.getWeatherIcon(isDay: true) ?? "sun.min.fill")
        dayLabel.text = cell.day
        dayLowLabel.text = cell.DayLow
        dayHighLabel.text = cell.DayHigh
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
