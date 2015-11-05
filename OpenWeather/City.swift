//
//  City.swift
//  OpenWeather
//
//  Created by Mariano Molina on 11/2/15.
//  Copyright © 2015 Funka.la. All rights reserved.
//

import Foundation

class City {
    let name: String
    let weather: WeatherType
    let lat: Double
    let lon: Double
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let image: String
    
    init(cityName: String, cityWeather: WeatherType, cityLat: Double, cityLon: Double, cityTemp: Double, cityMinTemp: Double, cityMaxTemp: Double, cityImage: String) {
        self.name     = cityName
        self.weather  = cityWeather
        self.lat      = cityLat
        self.lon      = cityLon
        self.temp     = cityTemp
        self.temp_min = cityMinTemp
        self.temp_max = cityMaxTemp
        self.image    = cityImage
    }
    
}