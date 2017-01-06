//
//  GraffitiManager.swift
//  Graffiti
//
//  Created by Benjamín Garrido Barreiro on 6/1/17.
//  Copyright © 2017 Benjamín Garrido Barreiro. All rights reserved.
//

import Foundation


class GraffitiManager {
    static let sharedInstance = GraffitiManager()
    
    var graffitis : [Graffiti] = [Graffiti]()
    
    func save() {
        if let url = databaseURL() {
            NSKeyedArchiver.archiveRootObject(graffitis, toFile: url.path)
        } else {
            print("Error guardando datos.")
        }
    }
    
    func load() {
        if let url = databaseURL(),
            let saveData = NSKeyedUnarchiver.unarchiveObject(withFile: url.path) as? [Graffiti]{
            graffitis = saveData
        } else {
            print("Error cargando datos.")
        }
    }
    
    func databaseURL() -> URL? {
        if let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let url  = URL(fileURLWithPath: documentDirectory)
            return url.appendingPathComponent("graffitis.data")
        } else {
            return nil
        }
    }
    
    func imagesURL() -> URL? {
        if let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let url = URL(fileURLWithPath: documentDirectory)
            return url
        } else {
            return nil
        }
    }
}
