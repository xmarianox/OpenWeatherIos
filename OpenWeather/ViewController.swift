//
//  ViewController.swift
//  OpenWeather
//
//  Created by Mariano Molina on 27/10/15.
//  Copyright © 2015 Funka.la. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Outlet
    @IBOutlet weak var ciudadSeleccionada: UILabel!
    @IBOutlet weak var temperaturaActual: UILabel!
    @IBOutlet weak var unidadSeleccionada: UISegmentedControl!
    
    // coleccion de cuidades
    var ciudades = [String]()
    var ciudadSeleccionadaValue: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // cargamos la lista de ciudades
        let pathCityList = NSBundle.mainBundle().pathForResource("ciudades", ofType: "plist")
        ciudades = NSArray(contentsOfFile: pathCityList!) as! [String]
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let pref = NSUserDefaults.standardUserDefaults()
        if let mCiudad = pref.valueForKey("nombreCiudad") as? String {
            getTempForCity(mCiudad)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ciudades.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ciudades[row]
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ciudadSeleccionadaValue = ciudades[row]
    }
    
    @IBAction func seleccionarCiudad() {
        if let mCiudad = ciudadSeleccionadaValue {
            let pref = NSUserDefaults.standardUserDefaults()
            pref.setValue(mCiudad, forKey: "nombreCiudad")
            pref.synchronize()
            
            getTempForCity(mCiudad)
            
        }
    }
    
    func convertUnits(tempKelvin: Double) -> Double {
        if (unidadSeleccionada.selectedSegmentIndex == 0) {
            let resultadoC = tempKelvin - 273.15
            return resultadoC
        } else {
            let resultadoF = 1.8 * tempKelvin - 273.15 + 32
            return resultadoF
        }
    }
    
    
    func getTempForCity(city: String) {
        
        self.ciudadSeleccionada.text = "\(city)"
        
        let mService = WeatherService()
        mService.getCityWeather(generarURLValida(city), callback: { temperatura in
            let mTemp = self.convertUnits(temperatura)
            self.temperaturaActual.text = "\(mTemp)"
        })
    }
    
    
    /*
     *  retorna una url valida
     */
    func generarURLValida(url: String) -> String {
        return url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
    }
}

