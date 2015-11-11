//
//  ViewController.swift
//  OpenWeather
//
//  Created by Mariano Molina on 27/10/15.
//  Copyright © 2015 Funka.la. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var ciudadSeleccionada: UILabel!
    @IBOutlet weak var temperaturaActual: UILabel!
    @IBOutlet weak var unidadSeleccionada: UISegmentedControl!
    @IBOutlet weak var panelAddCity: UIView!
    @IBOutlet weak var tempMinView: UILabel!
    @IBOutlet weak var tempMaxView: UILabel!
    @IBOutlet weak var actionIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapButton: UIButton! {
        didSet {
            if let imageView = mapButton.imageView {
                imageView.image = imageView.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                imageView.tintColor = UIColor.whiteColor()
                mapButton.setImage(imageView.image, forState: UIControlState.Normal)
            }
        }
    }
    
    // MARK: - ConstraintsOutlets
    @IBOutlet weak var bottomPanel: NSLayoutConstraint!
    
    // MARK: - Flags
    var isPanelVisible = true;
    
    // MARK: - CityData
    var ciudades = [String]()
    var ciudadSeleccionadaValue: String!
    var cityObjSelect: City!
    
    // MARK: - AppLifeCircle
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
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // MARK: - PickerViewMethods
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
    
    // MARK: - Actions
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
    
    
    // MARK: - Segue
    // Pasamos la data nuevo viewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "viewControllerToMapViewController" {
            if let mapController = segue.destinationViewController as? MapViewController {
                mapController.cityTitle = cityObjSelect.name
                mapController.cityCoords = CLLocationCoordinate2D(latitude: cityObjSelect.lat, longitude: cityObjSelect.lon)
            }
        }
    }
    
    // MARK: - Service
    // traemos la data de la ciudad desde el service
    func getTempForCity(myCity: String) {
        
        let mService = WeatherService()
        mService.getCityWeather(generarURLValida(myCity), callback: { City in
            
            self.actionIndicator.stopAnimating()
            
            if let cityObj = City {
                
                self.cityObjSelect = cityObj
                
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
    
    // MARK: - Helpers
    /*
    *   Retorna la temperatura en String
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
    /*
     *  retorna una url valida
     */
    func generarURLValida(url: String) -> String {
        return url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
    }
    
}

