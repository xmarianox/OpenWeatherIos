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
    @IBOutlet weak var panelAddCity: UIView!
    @IBOutlet weak var tempMinView: UILabel!
    @IBOutlet weak var tempMaxView: UILabel!
    @IBOutlet weak var actionIndicator: UIActivityIndicatorView!
    
    // constraints
    @IBOutlet weak var bottomPanel: NSLayoutConstraint!
    var isPanelVisible = true;
    
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
        } else {
            ciudadSeleccionada.text = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    *   PickerView
    */
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
    
    /*
    *   Actions
    */
    @IBAction func seleccionarCiudad() {
        if let mCiudad = ciudadSeleccionadaValue {
            let pref = NSUserDefaults.standardUserDefaults()
            pref.setValue(mCiudad, forKey: "nombreCiudad")
            pref.synchronize()
            
            actionIndicator.startAnimating()
            getTempForCity(mCiudad)
            
            // animation
            togglePanel()
        }
    } 
    
    @IBAction func unitsChange(sender: AnyObject) {
        let pref = NSUserDefaults.standardUserDefaults()
        if let mCiudad = pref.valueForKey("nombreCiudad") as? String {
            getTempForCity(mCiudad)
        }
    }
    
    @IBAction func togglePanel() {
        UIView.animateWithDuration(0.5) {
            self.bottomPanel.constant = self.isPanelVisible ? 0 : self.panelAddCity.frame.height * -1
            self.isPanelVisible = !self.isPanelVisible
            self.view.layoutIfNeeded()
        }
    }
    
    /*
    *   Helpers
    */
    func convertUnits(tempKelvin: Double) -> String {
        if (unidadSeleccionada.selectedSegmentIndex == 0) {
            let resultadoC: Int = Int(round(tempKelvin - 273.15))
            return "\(resultadoC)°"
        } else {
            let resultadoF: Int = Int(round(1.8 * tempKelvin - 273.15 + 32))
            return "\(resultadoF)°"
        }
    }
    
    
    func getTempForCity(myCity: String) {
        
        let mService = WeatherService()
        mService.getCityWeather(generarURLValida(myCity), callback: { City in
            
            self.actionIndicator.stopAnimating()
            
            if let cityObj = City {
                // city name
                self.ciudadSeleccionada.text = "\(cityObj.name)"
                // city temp
                self.temperaturaActual.text = "\(self.convertUnits(cityObj.temp))"
                // minTemp
                self.tempMinView.text = "\(self.convertUnits(cityObj.temp_min))"
                // maxTemp
                self.tempMaxView.text = "\(self.convertUnits(cityObj.temp_max))"
            } else {
                let alertaView = UIAlertController(title: "ERROR!", message: "No hay data!", preferredStyle: .Alert)
                
                let buttonCerrar = UIAlertAction(title: "Cerrar", style: .Cancel, handler: { (action) -> Void in
                    alertaView.dismissViewControllerAnimated(true, completion: nil)
                })
                
                alertaView.addAction(buttonCerrar)
                
                self.presentViewController(alertaView, animated: true, completion: nil)
            }
            
        })
    }
    
    
    /*
     *  retorna una url valida
     */
    func generarURLValida(url: String) -> String {
        return url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
    }
}

