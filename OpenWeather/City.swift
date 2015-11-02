//
//  City.swift
//  OpenWeather
//
//  Created by Mariano Molina on 11/2/15.
//  Copyright © 2015 Funka.la. All rights reserved.
//

import Foundation

class City {
    var name: String
    var temp: Double
    var temp_min: Double
    var temp_max: Double
    
    
    init(cityName: String, cityTemp: Double, cityMinTemp: Double, cityMaxTemp: Double) {
        self.name = cityName
        self.temp = cityTemp
        self.temp_min = cityMinTemp
        self.temp_max = cityMaxTemp
    }
    
}