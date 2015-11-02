//
//  WeatherService.swift
//  OpenWeather
//
//  Created by Mariano Molina on 27/10/15.
//  Copyright © 2015 Funka.la. All rights reserved.
//

import Foundation

class WeatherService {
    
    func getCityWeather(cityName: String, callback: City -> ()) {
        
        let apiEndPoint: String = "http://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=0ddb8e025e338dc2d891dac7f43356e0"
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
                    
                    let cityObj = City(cityName: nombreCiudad, cityLat: latitud, cityLon: longitud, cityTemp: temperatura, cityMinTemp: temperaturaMin, cityMaxTemp: temperaturaMax)
                    
                    print("Nueva Ciudad: \(cityObj.name) temp: \(cityObj.temp) temp_min: \(cityObj.temp_min) temp_max: \(cityObj.temp_max)")
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        callback(cityObj)
                    }
                    
                } catch let error {
                    // no se logro convertir en JSON la data que le pase
                    dispatch_async(dispatch_get_main_queue()) {
                        //callback(0)
                        print(error)
                    }
                }
                
            } else {
                // No se pudo descargar la data
                dispatch_async(dispatch_get_main_queue()) {
                    //callback(0)
                    print("No se pudo descargar la data!!!")
                }
            }
        }
        
    }
    
    
}