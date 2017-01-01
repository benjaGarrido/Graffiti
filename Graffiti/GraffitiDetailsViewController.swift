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
        lblAddress.text = (taggedGraffiti?.graffitiAddress)!
    }
}

extension GraffitiDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func takePictureTapped () {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let takePhotoAction = UIAlertAction(title: "Sacar Foto", style: .default) { _ in
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




