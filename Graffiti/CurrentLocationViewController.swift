//
//  CurrentLocationViewController.swift
//  Graffiti
//
//  Created by Benjamín Garrido Barreiro on 26/12/16.
//  Copyright © 2016 Benjamín Garrido Barreiro. All rights reserved.
//

import UIKit
import MapKit

class CurrentLocationViewController: UIViewController {
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tagButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var graffiti: Graffiti?
    var updatingLocation = false {
        didSet {
            if updatingLocation {
                getButton.setImage(#imageLiteral(resourceName: "btn_localizar_off"), for: .normal)
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                getButton.isUserInteractionEnabled = false
            } else {
                getButton.setImage(#imageLiteral(resourceName: "btn_localizar_on"), for: .normal)
                activityIndicator.isHidden = true
                activityIndicator.stopAnimating()
                getButton.isUserInteractionEnabled = true
            }
        }
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Asignamos la imagen del navbar
        let image = UIImage(named: "img_navbar_title")
        self.navigationItem.titleView = UIImageView(image: image)
        
        // Siempre que accedemos a la vista la variable debe estar a false
        updatingLocation = false
        
    }

    @IBAction func getLocation(_ sender: Any) {
        startLocationManager()
    }
    
    func startLocationManager() {
        // Evaluamos en que estado se encuentran los permisos para localizar al usuario
        let authStatus = CLLocationManager.authorizationStatus()
        switch authStatus{
        case .notDetermined:
            //Cuando no sabemos en que estado está, lo pedimos
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            //Mostraremos un mensaje (alert) al usuario
            showLocationServicesDiniedAlert()
        default:
            if CLLocationManager.locationServicesEnabled() {
                self.updatingLocation = true
                self.tagButton.isEnabled = false
                
                //Creamos los delegados del locationManager
                locationManager.delegate = self
                //Definimos el nivel de preción que queremos en la localización
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                //Pedimos que haga la localizacion
                locationManager.requestLocation()
                //Realizamos un zoom en el mapView (definimos una región alrededor de 1km)
                let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
                mapView.setRegion(mapView.regionThatFits(region), animated: true)
            }
        }
    }
    
    func showLocationServicesDiniedAlert() {
        let alert = UIAlertController(title: "Localización desactivada", message: "Por favor, activa la localización para esta app en Ajustes", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension CurrentLocationViewController: CLLocationManagerDelegate {
    
}
