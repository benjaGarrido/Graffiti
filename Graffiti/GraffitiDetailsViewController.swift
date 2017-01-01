//
//  GraffitiDetailsViewController.swift
//  Graffiti
//
//  Created by Benjamín Garrido Barreiro on 1/1/17.
//  Copyright © 2017 Benjamín Garrido Barreiro. All rights reserved.
//

import UIKit

class GraffitiDetailsViewController: UIViewController {
    @IBOutlet weak var imgGraffiti: UIImageView!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    var taggedGraffiti : Graffiti?
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Asignamos la imagen del navbar
        let image = UIImage(named: "img_navbar_title")
        self.navigationItem.titleView = UIImageView(image: image)
        
        // Añadimos a la imagen un reconocedor de gestos
        let takePictureGesture = UITapGestureRecognizer(target: self, action: #selector(takePictureTapped))
        self.imgGraffiti.addGestureRecognizer(takePictureGesture)
        
        configureLabels()
    }

    func configureLabels() {
        lblLatitude.text = String(format: "%.8f", (taggedGraffiti?.coordinate.latitude)!)
        lblLongitude.text = String(format: "%.8f", (taggedGraffiti?.coordinate.longitude)!)
        lblAddress.text = String(format: "%.8f", (taggedGraffiti?.graffitiAddress)!)
    }
}
