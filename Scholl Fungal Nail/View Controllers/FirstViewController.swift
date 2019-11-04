//
//  FirstViewController.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 30/10/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import UIKit
import CoreML
import Vision

class FirstViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - Properties
    let imagePicker = UIImagePickerController()

    //MARK: - Outlets
    @IBOutlet weak var selectedImage: UIImageView!

    //MARK: - Actions
    @IBAction func cameraTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        //imagePicker.cameraOverlayView = ???
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let userPickedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided with the following: \(info)")
        }

        selectedImage.image = userPickedImage

        guard let ciImage = CIImage(image: userPickedImage) else {
            fatalError("Couldn't convert uiimage to CIImage")
        }

        detect(image: ciImage)
        imagePicker.dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let destination = segue.destination as? Results {
                //nextViewController.valueOfxyz = "XYZ"
        }
    }

        func detect(image: CIImage) {

            print("Called")

            guard let model = try? VNCoreMLModel(for: MyImageClassifier2_1().model) else {
                fatalError("Loading CoreML Model failed")
            }

            let request = VNCoreMLRequest(model: model) { (request, error) in

                guard let results = request.results as? [VNClassificationObservation] else {
                    fatalError("Model failed to process image")
                }

                print(results.first)
                self.navigationItem.title = results.first?.identifier
            }

            let handler = VNImageRequestHandler(ciImage: image)

            do {
                try! handler.perform([request])
            }
            catch {
                print(error)
            }
        }

}


