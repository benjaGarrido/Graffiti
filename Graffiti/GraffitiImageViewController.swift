//
//  GraffitiImageViewController.swift
//  Graffiti
//
//  Created by Benjamín Garrido Barreiro on 6/1/17.
//  Copyright © 2017 Benjamín Garrido Barreiro. All rights reserved.
//

import UIKit

class GraffitiImageViewController: UIViewController {
    
    @IBOutlet weak var imgGraffiti: UIImageView!

    var selectedCallout : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let selectedCallout = selectedCallout {
            imgGraffiti.image = selectedCallout
        }
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
