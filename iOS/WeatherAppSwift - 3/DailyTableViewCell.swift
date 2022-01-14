//
//  DailyTableViewCell.swift
//  WeatherAppSwift - 3
//
//  Created by Melih Cüneyter on 10.01.2022.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dailyWeekdayLabel: UILabel!
    @IBOutlet weak var dailyImageView: UIImageView!
    @IBOutlet weak var dailyLowLabel: UILabel!
    @IBOutlet weak var dailyHighLabel: UILabel!
    
    var dailyWeather: DailyWeather! {
        didSet {
            dailyImageView.image = UIImage(systemName: dailyWeather.dailyIcon)
            dailyWeekdayLabel.text = dailyWeather.dailyWeekday
            dailyHighLabel.text = "Max: \(dailyWeather.dailyHigh)°"
            dailyLowLabel.text = "Min:  \(dailyWeather.dailyLow)°"
        }
    }
}
