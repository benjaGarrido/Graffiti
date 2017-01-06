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
    var selectedCalloutImage: UIImage?
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GraffitiManager.sharedInstance.load()
        
        // Asignamos la imagen del navbar
        let image = UIImage(named: "img_navbar_title")
        self.navigationItem.titleView = UIImageView(image: image)
        
        // Siempre que accedemos a la vista la variable debe estar a false
        updatingLocation = false
    }

    override func viewWillAppear(_ animated: Bool) {
        mapView.delegate = self
        mapView.addAnnotations(GraffitiManager.sharedInstance.graffitis)
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
                
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.requestLocation()
                
                //hacemos zoom sobre la localización del usuario
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
    
    func stringFromPlacemark(placemark: CLPlacemark) ->String {
        var line1 = ""
        //Nombre de la calle
        if let s = placemark.thoroughfare {
            line1 += s + ", "
        }
        //Numero de la calle
        if let s = placemark.subThoroughfare {
            line1 += s
        }
        var line2 = ""
        //Codigo postal
        if let s = placemark.postalCode {
            line2 += s + " "
        }
        //Localidad
        if let s = placemark.locality {
            line2 += s
        }
        var line3 = ""
        //Localidad
        if let s = placemark.administrativeArea {
            line3 += s + " "
        }
        //País
        if let s = placemark.country {
            line3 += s
        }
        return line1 + "\n" + line2  + "\n" + line3
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TagGraffiti" {
            let navigationController = segue.destination as! UINavigationController
            let detailsViewController = navigationController.topViewController as! GraffitiDetailsViewController
            detailsViewController.taggedGraffiti = self.graffiti
            detailsViewController.delegate = self
        }
        if segue.identifier == "showPinImage" {
            let navigationController = segue.destination as! UINavigationController
            let graffitiImageViewController = navigationController.topViewController as! GraffitiImageViewController
            graffitiImageViewController.selectedCallout = selectedCalloutImage
        }
    }
}

extension CurrentLocationViewController: GraffitiDetailsViewControllerDelegate {
    func graffitiDidFinishGetTagged(sender: GraffitiDetailsViewController, taggedGraffiti: Graffiti) {
        GraffitiManager.sharedInstance.graffitis.append(taggedGraffiti)
        GraffitiManager.sharedInstance.save()
    }
}

extension CurrentLocationViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("******* Error en Core Location *******")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let newLocation = locations.last else { return }
        
        let latitude = Double(newLocation.coordinate.latitude)
        let longitude = Double(newLocation.coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(newLocation) { (placemarks, error) in
            if error == nil {
                var address = "No se ha podido determinar"
                if let placemark = placemarks?.last {
                    address = self.stringFromPlacemark(placemark: placemark)
                }
                self.graffiti = Graffiti(address: address, latitude: latitude, longitude: longitude, image: "")
            }
            self.updatingLocation = false
            self.tagButton.isEnabled = true
        }
    }
}

extension CurrentLocationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "graffitiPin")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "graffitiPin")
        } else {
            annotationView?.annotation = annotation
        }
        
        if let place = annotation as? Graffiti {
            let imageName = place.graffitiImageName
            if let imagesURL = GraffitiManager.sharedInstance.imagesURL() {
                let imageData = try! Data(contentsOf: imagesURL.appendingPathComponent(imageName))
                selectedCalloutImage = UIImage(data: imageData)
                let image = resizeImage(image: selectedCalloutImage!, newWidth: 40.0)
                let btnImageView = UIButton(frame: CGRect(x: 0, y: 0, width: 40.0, height: 40.0))
                btnImageView.setImage(image, for: .normal)
                annotationView?.leftCalloutAccessoryView = btnImageView
                annotationView?.image = UIImage(named: "img_pin")
                annotationView?.canShowCallout = true
            }
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.leftCalloutAccessoryView{
            performSegue(withIdentifier: "showPinImage", sender: view)
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
