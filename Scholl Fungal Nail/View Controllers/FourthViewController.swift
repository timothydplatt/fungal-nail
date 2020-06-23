//
//  FourthViewController.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 30/10/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import UIKit

class FourthViewController: UIViewController {

    @IBOutlet weak var cardNum1: UIView!
    @IBOutlet weak var cardNum2: UIView!
    @IBOutlet weak var cardNum3: UIView!
    @IBAction func viewProduct1(_ sender: UIButton) {
        performSegue(withIdentifier: "productDetail", sender: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        setCardShadows()
    }

        func setCardShadows() {
            cardNum1.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            cardNum1.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            cardNum1.layer.shadowOpacity = 1.0
            cardNum1.layer.shadowRadius = 0.0
            cardNum1.layer.masksToBounds = false
            cardNum1.layer.cornerRadius = 4.0

            cardNum2.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            cardNum2.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            cardNum2.layer.shadowOpacity = 1.0
            cardNum2.layer.shadowRadius = 0.0
            cardNum2.layer.masksToBounds = false
            cardNum2.layer.cornerRadius = 4.0

            cardNum3.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            cardNum3.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            cardNum3.layer.shadowOpacity = 1.0
            cardNum3.layer.shadowRadius = 0.0
            cardNum3.layer.masksToBounds = false
            cardNum3.layer.cornerRadius = 4.0

        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productDetail" {
            guard let viewController = segue.destination as? FourthViewController else {
                return
            }
        }
    }

}
