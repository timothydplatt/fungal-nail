//
//  HomeVC.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 30/10/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - Properties
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage? = nil

    //MARK: - Actions
    @IBAction func cameraTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }

    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        //TODO: - imagePicker.cameraOverlayView = ???
    }

    //Allow user to choose an image.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let pickedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided with the following: \(info)")
        }

        selectedImage = pickedImage
        imagePicker.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "test", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "test" {
            guard let viewController = segue.destination as? ResultsVC else {
                return
            }
            viewController.resultImage = selectedImage
        }
    }

}


