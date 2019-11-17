//
//  HomeVC.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 17/11/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    //MARK: - Properties
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage? = nil

    //MARK: - IB Outlets
    @IBOutlet weak var leadingMask: UIView!
    @IBOutlet weak var trailingMask: UIView!
    @IBOutlet weak var topMask: UIView!
    @IBOutlet weak var bottomMask: UIView!
    @IBOutlet weak var introductionCard: UIView!
    @IBOutlet weak var trackerCard: UIView!
    @IBOutlet weak var compareCard: UIView!
    @IBOutlet weak var quizCard: UIView!

    //MARK: - IB Actions
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func compareButton(_ sender: UIButton) {
        performSegue(withIdentifier: "comparison", sender: nil)
    }
    @IBAction func takeQuizButton(_ sender: Any) {
        performSegue(withIdentifier: "takeQuiz", sender: nil)
    }
    @IBAction func takeTourButton(_ sender: UIButton) {
    }
    @IBAction func noThanksButton(_ sender: UIButton) {
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColours()
        setNavigationLogo()
        setCardShadows()

        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }

    func setBackgroundColours() {
        self.view.backgroundColor = UIColor(red: 138/255, green: 222/255, blue: 204/255, alpha: 1)
        topMask.backgroundColor = UIColor(red: 138/255, green: 222/255, blue: 204/255, alpha: 1)
        bottomMask.backgroundColor = UIColor(red: 138/255, green: 222/255, blue: 204/255, alpha: 1)
        leadingMask.backgroundColor = UIColor(red: 138/255, green: 222/255, blue: 204/255, alpha: 1)
        trailingMask.backgroundColor = UIColor(red: 138/255, green: 222/255, blue: 204/255, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }

    func setNavigationLogo() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo1_toto.png")
        imageView.image = image
        navigationItem.titleView = imageView
    }

    func setCardShadows() {
        introductionCard.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        introductionCard.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        introductionCard.layer.shadowOpacity = 1.0
        introductionCard.layer.shadowRadius = 0.0
        introductionCard.layer.masksToBounds = false
        introductionCard.layer.cornerRadius = 4.0

        compareCard.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        compareCard.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        compareCard.layer.shadowOpacity = 1.0
        compareCard.layer.shadowRadius = 0.0
        compareCard.layer.masksToBounds = false
        compareCard.layer.cornerRadius = 4.0

        quizCard.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        quizCard.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        quizCard.layer.shadowOpacity = 1.0
        quizCard.layer.shadowRadius = 0.0
        quizCard.layer.masksToBounds = false
        quizCard.layer.cornerRadius = 4.0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "diagnosis" {
            guard let viewController = segue.destination as? ResultsVC else {
                return
            }
            viewController.resultImage = selectedImage
        } else if segue.identifier == "comparison" {
            if let comparisonVC = segue.destination as? CompareVC {
                //comparisonVC.bottomImage = selectedImage
            }
        }
    }

}

extension HomeVC: UINavigationControllerDelegate {

}

extension HomeVC: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let pickedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided with the following: \(info)")
        }

        selectedImage = pickedImage
        imagePicker.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "diagnosis", sender: nil)
    }
}
