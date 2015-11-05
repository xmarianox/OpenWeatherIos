//
//  WeatherService.swift
//  OpenWeather
//
//  Created by Mariano Molina on 27/10/15.
//  Copyright © 2015 Funka.la. All rights reserved.
//

import Foundation

class WeatherService {
    
    func getCityWeather(cityName: String, callback: City? -> ()) {
        
        let apiEndPoint: String = "http://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=0ddb8e025e338dc2d891dac7f43356e0&lang=es"
        let endPointUrl = NSURL(string: apiEndPoint)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            
            if let data = NSData(contentsOfURL: endPointUrl!) {
                
                do {
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                    
                    let nombreCiudad   = jsonDictionary["name"] as! String
                    let latitud        = jsonDictionary["coord"]!["lat"] as! Double
                    let longitud       = jsonDictionary["coord"]!["lon"] as! Double
                    let temperatura    = jsonDictionary["main"]!["temp"] as! Double
                    let temperaturaMin = jsonDictionary["main"]!["temp_min"] as! Double
                    let temperaturaMax = jsonDictionary["main"]!["temp_max"] as! Double
                    
                    if let weatherDictionary = jsonDictionary["weather"] as? [NSDictionary] {
                        
                        let main = weatherDictionary[0]["main"] as! String
                        let description = weatherDictionary[0]["description"] as! String
                    
                        if let (weatherEnum, weatherImage) = self.setWeatherType(main, weatherDesc: description) {
                            
                            let cityObj = City(cityName: nombreCiudad, cityWeather: weatherEnum, cityLat: latitud, cityLon: longitud, cityTemp: temperatura, cityMinTemp: temperaturaMin, cityMaxTemp: temperaturaMax, cityImage: weatherImage)
                            
                            print("Nueva Ciudad: \(cityObj.name) - weather: \(cityObj.weather) - lat: \(latitud) - long: \(longitud) - temp: \(cityObj.temp) - temp_min: \(cityObj.temp_min) - temp_max: \(cityObj.temp_max) Imagen: \(cityObj.image)")
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                callback(cityObj)
                            }
                            
                        } else {
                            print("Clima no contemplado \(main)")
                        }
                    }
                    
                } catch let error {
                    // no se logro convertir en JSON la data que le pase
                    dispatch_async(dispatch_get_main_queue()) {
                        callback(nil)
                        print(error)
                    }
                }
                
            } else {
                // No se pudo descargar la data
                dispatch_async(dispatch_get_main_queue()) {
                    callback(nil)
                    print("No se pudo descargar la data!!!")
                }
            }
        }
        
    }
    
    private func setWeatherType(weather: String, weatherDesc: String) -> (WeatherType, String)? {
        switch weather.lowercaseString {
            case "clear":
                return (.Clear(weatherDesc), "clear")

            case "clouds":
                return (.Clouds(weatherDesc), "clouds")
    
            case "rain":
                return (.Rain(weatherDesc), "rain")
          
            case "thunderstorm":
                return (.Thunderstorm(weatherDesc), "thunderstorm")
           
            case "snow":
                return (.Snow(weatherDesc), "snow")
        
            case "drizzle":
                return (.Drizzle(weatherDesc), "drizzle")
           
            case "atmosphere":
                return (.Atmosphere(weatherDesc), "atmosphere")
         
            case "extreme":
                return (.Extreme(weatherDesc), "extreme")
     
            case "additional":
                return (.Additional(weatherDesc), "additional")
     
            default:
                return nil
        }
    }
}