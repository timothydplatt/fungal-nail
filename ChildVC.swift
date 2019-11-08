//
//  ChildVC.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 05/11/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import UIKit

class ChildVC: UIViewController {

    let treatmentTrackerHistory = [true,true,false,true,false,true,false]

    @IBOutlet weak var treatmentTrackerCardTitle: UILabel!

    @IBOutlet weak var treatmentTrackerCardPercentageView: UIView!

    @IBOutlet weak var treatmentTrackerCardPercentage: UILabel!

    @IBOutlet weak var treatmentTrackerCardButton: UIButton!

    @IBOutlet weak var treatmentTrackerCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCollectionViewCells()
    }

    func registerCollectionViewCells(){
        let treatmentTrackerCollectionViewCell = UINib(nibName: "TreatmentTrackerCollectionViewCell", bundle: nil)

        self.treatmentTrackerCollectionView.register(treatmentTrackerCollectionViewCell, forCellWithReuseIdentifier: "treatmentTrackerCell")
    }
}

extension ChildVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print(treatmentTrackerHistory.count)
        return treatmentTrackerHistory.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "treatmentTrackerCell", for: indexPath) as! TreatmentTrackerCollectionViewCell
        //print(treatmentTrackerHistory[indexPath.row])
        if treatmentTrackerHistory[indexPath.row] == true {
            cell.treatmentTrackerButton.isSelected = true
            cell.treatmentTrackerButton.tintColor = UIColor.systemGreen
        } else {
            cell.treatmentTrackerButton.isSelected = false
        }

        cell.treatmentTrackerLabel.text = String(treatmentTrackerHistory[indexPath.row])
        cell.treatmentTrackerButton.tag = indexPath.row
        cell.treatmentTrackerButton.addTarget(self, action: #selector(treatmentButtonTapped), for: UIControl.Event.touchUpInside)

        return cell
    }

    @IBAction func treatmentButtonTapped(sender : UIButton){
        sender.isSelected = !sender.isSelected

        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            //sender.isSelected = !sender.isSelected
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                sender.transform = .identity
            }, completion: nil)

            if sender.isSelected == true {
                sender.tintColor = UIColor.systemGreen
            } else {
                sender.tintColor = UIColor.gray
            }
        }
    }

}
