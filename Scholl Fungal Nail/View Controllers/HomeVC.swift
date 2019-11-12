//
//  HomeVC.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 30/10/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UINavigationControllerDelegate {

    //MARK: - Properties
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage? = nil

    //MARK: - IB Outlets

    //MARK: - IB Actions
    @IBAction func cameraTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func c1NotNotButton(_ sender: Any) {
    }

    @IBAction func c1TakeToutButton(_ sender: Any) {
    }

    @IBAction func c3ViewMoreButton(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil);
//        let vc = storyboard.instantiateViewController(withIdentifier: "ResultsScreen") ;
//        self.present(vc, animated: true, completion: nil);
        performSegue(withIdentifier: "comparison", sender: nil)
    }

    @IBAction func c4ViewMoreButton(_ sender: Any) {
    }

    @IBAction func editButtonTapped(sender : UIButton){
        //print(sender.tag)
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            sender.isSelected = !sender.isSelected
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                sender.transform = .identity
            }, completion: nil)
        }
    }

    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        //TODO: - imagePicker.cameraOverlayView = ???
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "test" {
            guard let viewController = segue.destination as? ResultsVC else {
                return
            }
            viewController.resultImage = selectedImage
        } else if segue.identifier == "embedChildSegue" {
            if let childVC = segue.destination as? ChildVC {
            }
        } else if segue.identifier == "comparison" {
            if let comparisonVC = segue.destination as? CompareVC {
                comparisonVC.bottomImage = selectedImage
            }
        }
    }

}

extension HomeVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let pickedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided with the following: \(info)")
        }

        selectedImage = pickedImage
        imagePicker.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "test", sender: nil)
    }
}
