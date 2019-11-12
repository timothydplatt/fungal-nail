//
//  ChildVC.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 05/11/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import UIKit
import RealmSwift

class ChildVC: UIViewController {
    
    //MARK: - Properties
    let realm = try! Realm()
    var treatmentTrackerArray: Results<Compliance>?
    let date = Date()
    let dateFormatter = DateFormatter()
    var dateMinusSeven: Date?

    //MARK: - IB Outlets
    @IBOutlet weak var treatmentTrackerCardTitle: UILabel!
    @IBOutlet weak var treatmentTrackerCardPercentageView: UIView!
    @IBOutlet weak var treatmentTrackerCardPercentage: UILabel!
    @IBOutlet weak var treatmentTrackerCardButton: UIButton!
    @IBOutlet weak var treatmentTrackerCollectionView: UICollectionView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var visualizationView: UIView!
    @IBOutlet weak var visualizationWidth: NSLayoutConstraint!
    @IBOutlet weak var visualizatonHeight: NSLayoutConstraint!
    
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCollectionViewCells()
        dateMinusSeven = Calendar.current.date(byAdding: .day, value: -7, to: date)
        updateDatabaseArray()
        updatePercentageViewSize(3)
        dateFormatter.dateFormat = "EEEE"
        roundLabelViewRadius()
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func registerCollectionViewCells(){
        let treatmentTrackerCollectionViewCell = UINib(nibName: "TreatmentTrackerCollectionViewCell", bundle: nil)
        
        self.treatmentTrackerCollectionView.register(treatmentTrackerCollectionViewCell, forCellWithReuseIdentifier: "treatmentTrackerCell")
    }

    func updateDatabaseArray(){
        treatmentTrackerArray = realm.objects(Compliance.self).filter("dateTaken BETWEEN %@", [dateMinusSeven, date]).sorted(byKeyPath: "dateTaken")
    }

    func roundLabelViewRadius(){
        treatmentTrackerCardPercentageView.layer.cornerRadius = (treatmentTrackerCardPercentageView.layer.frame.size.width/2) + 1
        treatmentTrackerCardPercentage.clipsToBounds = true

        var count = 0
        for i in treatmentTrackerArray! {
            if i.takenMedication == true {
                count+=1
            }
        }
        treatmentTrackerCardPercentage.text = String(count)
    }

    func updatePercentageViewSize(_ streak: Int) {
        //let multiplier = CGFloat(streak/7)
        UIView.animate(withDuration: 1.0, animations: {
            self.visualizationView.frame.size.width += 50
            self.visualizationWidth.constant += 250
            //self.visualizationView.transform = CGAffineTransform(translationX: -50, y: 50)
        }) { (complete) in
            print("amen")
        }

        visualizationView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        visualizationView.layer.cornerRadius = (visualizationView.layer.frame.size.width/2)
        visualizationView.clipsToBounds = true
    }
}

extension ChildVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return treatmentTrackerArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "treatmentTrackerCell", for: indexPath) as! TreatmentTrackerCollectionViewCell
        if treatmentTrackerArray![indexPath.row].takenMedication == true {
            cell.treatmentTrackerButton.isSelected = true
            cell.treatmentTrackerButton.tintColor = UIColor.systemGreen
        } else {
            cell.treatmentTrackerButton.isSelected = false
            cell.treatmentTrackerButton.tintColor = UIColor.gray
        }

        let longDate = dateFormatter.string(from: treatmentTrackerArray![indexPath.row].dateTaken!)
        let shortDate = String(longDate.prefix(3))
        cell.treatmentTrackerLabel.text = shortDate

        cell.treatmentTrackerButton.tag = indexPath.row
        cell.treatmentTrackerButton.addTarget(self, action: #selector(treatmentButtonTapped), for: UIControl.Event.touchUpInside)
        
        return cell
    }
    
    @IBAction func treatmentButtonTapped(sender : UIButton){
        sender.isSelected = !sender.isSelected

        let complianceEntry = Compliance()

        let primaryKey = treatmentTrackerArray![sender.tag].id
        let dateToEdit = treatmentTrackerArray![sender.tag].dateTaken
        let currentTakenMedicationState = treatmentTrackerArray![sender.tag].takenMedication
        let newTakenMedicationState = !currentTakenMedicationState

        complianceEntry.id = primaryKey
        complianceEntry.dateTaken = dateToEdit
        complianceEntry.takenMedication = newTakenMedicationState

        do {
            try self.realm.write {
                self.realm.add(complianceEntry, update: .all)
                //updateDatabaseArray()
                treatmentTrackerCollectionView.reloadData()
            }
        } catch {
            print("Error saving context \(error)")
        }
    }
    
}
