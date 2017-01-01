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
    }

}

