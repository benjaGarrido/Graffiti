//
//  GraffitiDetailsViewController.swift
//  Graffiti
//
//  Created by Benjamín Garrido Barreiro on 1/1/17.
//  Copyright © 2017 Benjamín Garrido Barreiro. All rights reserved.
//

import UIKit

protocol GraffitiDetailsViewControllerDelegate: class {
    func graffitiDidFinishGetTagged (sender: GraffitiDetailsViewController, taggedGraffiti: Graffiti)
}

class GraffitiDetailsViewController: UIViewController {
    
    weak var delegate: GraffitiDetailsViewControllerDelegate?
    
    @IBOutlet weak var imgGraffiti: UIImageView!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    var taggedGraffiti : Graffiti?
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveGraffiti(_ sender: Any) {
        if let image = imgGraffiti.image {
            let randomName = UUID().uuidString.appending(".png")
            if let url = GraffitiManager.sharedInstance.imagesURL()?.appendingPathComponent(randomName),
                let imageData = UIImagePNGRepresentation(image){
                do {
                    try imageData.write(to: url)
                } catch (let error) {
                    print("Error salvando la imagen: \(error)")
                }
            }
            
            taggedGraffiti = Graffiti(address: lblAddress.text!, latitude: Double(lblLatitude.text!)!, longitude: Double(lblLongitude.text!)!, image: randomName)
            
            if let taggedGraffiti = taggedGraffiti {
                delegate?.graffitiDidFinishGetTagged(sender: self, taggedGraffiti: taggedGraffiti)
            }
        }
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
        lblAddress.text = taggedGraffiti?.graffitiAddress
    }
}

extension GraffitiDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func takePictureTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let takePhotoAction = UIAlertAction(title: "Sacar foto", style: .default) { _ in
            self.takePhotoWithCamera()
        }
        alertController.addAction(takePhotoAction)
        
        let chooseFromLibraryAction = UIAlertAction(title: "Elegir de la librería", style: .default) { _ in
            self.choosePhotoFromLibrary()
        }
        alertController.addAction(chooseFromLibraryAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageTaken = info[UIImagePickerControllerEditedImage] as? UIImage
        imgGraffiti.image = imageTaken
        btnSave.isEnabled = true
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}





