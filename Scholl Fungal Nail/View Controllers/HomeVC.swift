//
//  HomeVC.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 30/10/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import RealmSwift
import UIKit

class HomeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    //MARK: - Properties
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage? = nil
//    let buttonImages = [UIImage(named: "Checkbox"),UIImage(named: "Checkbox"),UIImage(named: "Checkbox"), UIImage(named: "UnCheckbox"), UIImage(named: "UnCheckbox")]
    let buttonImages = [false,true,false,true,false]
    let realm = try! Realm()
    var complianceArray: Results<Compliance>?

    //MARK: - Actions
    @IBAction func cameraTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }


    @IBAction func compareButton(_ sender: UIButton) {

    }

    @IBAction func editButtonTapped(sender : UIButton){
        print(sender.tag)
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
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        //TODO: - imagePicker.cameraOverlayView = ???

//        let complianceEntry = Compliance()
//        complianceEntry.dateTaken = Date()
//        complianceEntry.id = 11
//        complianceEntry.takenMedication = true
//        do {
//            try self.realm.write {
//                self.realm.add(complianceEntry)
//            }
//        } catch {
//            print("Error saving context \(error)")
//        }
        


        let todayStart = Calendar.current.startOfDay(for: Date())
        let todayEnd: Date = {
          let components = DateComponents(day: 1, second: -1)
          return Calendar.current.date(byAdding: components, to: todayStart)!
        }()
        complianceArray = realm.objects(Compliance.self).filter("dateTaken BETWEEN %@", [todayStart, todayEnd])

    }

    //TODO: - Move to UIContainerView
    @IBAction func firstButtonTapped(_ sender: UIButton) {
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                    sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                }) { (success) in
                    sender.isSelected = !sender.isSelected
                    UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                        sender.transform = .identity
                    }, completion: nil)
                }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("NewTest")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "complianceCell", for: indexPath) as! ComplianceCollectionViewCell

        //cell.complianceButton.imageView?.image = buttonImages[indexPath.row]
        if buttonImages[indexPath.row] == true {
            cell.complianceButton.isSelected = true
        } else {
            cell.complianceButton.isSelected = false
        }

        //cell.complianceButton.setBackgroundImage(buttonImages[indexPath.row], for: .normal)
        cell.complianceButton.tag = indexPath.row
        cell.complianceButton.addTarget(self, action: #selector(editButtonTapped), for: UIControl.Event.touchUpInside)

        return cell
    }

    func buttonAction(sender : UIButton) {

       var selectedButtonCell = sender.superview as! ComplianceCollectionViewCell
        print(selectedButtonCell)
    }


    //MARK: - Select Image
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


