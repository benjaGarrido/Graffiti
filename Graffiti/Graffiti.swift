//
//  Graffiti.swift
//  Graffiti
//
//  Created by Benjamín Garrido Barreiro on 1/1/17.
//  Copyright © 2017 Benjamín Garrido Barreiro. All rights reserved.
//

import UIKit

class Graffiti: NSObject {

    let graffitiAddress : String
    let graffitiLatitude : Double
    let graffitiLongitude : Double
    let graffitiImageName : String
    
    init(address: String, latitude: Double, longitude: Double, imageName: String) {
        self.graffitiAddress = address
        self.graffitiLatitude = latitude
        self.graffitiLongitude = longitude
        self.graffitiImageName = imageName
    }
}
