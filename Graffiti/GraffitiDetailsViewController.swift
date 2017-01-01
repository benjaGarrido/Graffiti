//
//  GraffitiDetailsViewController.swift
//  Graffiti
//
//  Created by Benjamín Garrido Barreiro on 1/1/17.
//  Copyright © 2017 Benjamín Garrido Barreiro. All rights reserved.
//

import UIKit

class GraffitiDetailsViewController: UIViewController {

    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "img_navbar_title")
        self.navigationItem.titleView = UIImageView(image: image)
    }

}
