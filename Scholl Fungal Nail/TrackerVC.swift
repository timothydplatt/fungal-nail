//
//  TrackerVC.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 15/11/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import UIKit
import RealmSwift

class TrackerVC: UIViewController {

    var multiplier: Int = 1
    var parentViewWidth: CGFloat?
    var dummyData = ["YES", "NO","YES", "NO","YES", "NO", "YES"]
    lazy var realm: Realm = { return try! Realm() }()
    var defaultTrackerData = [Compliance]()
    var sortedDefaultArray = [Compliance]()
    var finalTrackerData = [Compliance]()
    var trackerData: Results<Compliance>?
    let toDate = Date()
    let dateFormatter = DateFormatter()
    var daysTreated: Int = 0
//    {
//        willSet(myNewValue){
//            resizeCircleView(by: myNewValue)
//        }
//    }

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var circleViewWidth: NSLayoutConstraint!
    @IBOutlet weak var circleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var trackerCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCollectionViewCells()
        setParentViewWidthProperty()
        setupCircleView()
        trackerCollectionView.delegate = self
        trackerCollectionView.dataSource = self
        initializeTrackerData()
    }

    override func viewDidAppear(_ animated: Bool) {
        resizeCircleView(by: daysTreated)
    }

    func registerCollectionViewCells(){
        let trackerViewCell = UINib(nibName: "TrackerViewCell", bundle: nil)
        self.trackerCollectionView.register(trackerViewCell, forCellWithReuseIdentifier: "trackerCell")
    }

    func setParentViewWidthProperty(){
        parentViewWidth = self.view.frame.size.width
    }

    func setupCircleView() {

        guard let parentViewWidth = parentViewWidth else { return }

        circleViewWidth.constant = parentViewWidth/7
        circleViewHeight.constant = parentViewWidth/7
        circleView.layer.cornerRadius = (parentViewWidth/7)/2
        circleView.clipsToBounds = true
        circleView.layer.allowsEdgeAntialiasing = true
        circleView.translatesAutoresizingMaskIntoConstraints = false
    }

    func resizeCircleView(by multiplier: Int) {

        circleViewWidth.constant = (parentViewWidth!/7) * CGFloat(multiplier * 2)
        circleViewHeight.constant = (parentViewWidth!/7) * CGFloat(multiplier * 2)

        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.view.layoutIfNeeded()
        },
                       completion: { finished in
        })

        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animation.fromValue = circleView.layer.cornerRadius
        animation.toValue = ((parentViewWidth!/7)*CGFloat(multiplier))
        circleView.layer.add(animation, forKey: nil)
        circleView.layer.cornerRadius = ((parentViewWidth!/7)*CGFloat(multiplier))
    }

    func initializeTrackerData() {
        createDefaultTrackerData()

        guard let fromDate = Calendar.current.date(byAdding: .day, value: -7, to: toDate) else { return }
        retrieveTrackerData(from: fromDate, to: toDate)
        dateFormatter.dateFormat = "EEEE"
        retrieveTrackerData(from: fromDate, to: toDate)

        createMergedTrackerData()
    }

    func createDefaultTrackerData(){

        for i in 0..<7 {
            let defaultEntry = Compliance()
            let dateToAdd = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
            defaultEntry.id = i
            defaultEntry.dateTaken = dateToAdd
            defaultEntry.takenMedication = false
            defaultTrackerData.append(defaultEntry)
        }
        sortedDefaultArray = defaultTrackerData.sorted(by: {$0.dateTaken! > $1.dateTaken!})
        //print(sortedDefaultArray.description)
    }

    func retrieveTrackerData(from fromDate: Date, to toDate: Date){
        trackerData = realm.objects(Compliance.self).filter("dateTaken BETWEEN %@", [fromDate, toDate]).sorted(byKeyPath: "dateTaken", ascending: false)
        //print(trackerData?.description)
    }

    func createMergedTrackerData() {
        for i in 0..<trackerData!.count {
            let diffInDays = Calendar.current.dateComponents([.day], from: trackerData![i].dateTaken!, to: Date()).day
            sortedDefaultArray[diffInDays!] = trackerData![i]
        }

        finalTrackerData = sortedDefaultArray.sorted(by: {$0.dateTaken! < $1.dateTaken!})

        for i in finalTrackerData {
            let complianceEntry = Compliance()

            complianceEntry.id = i.id
            complianceEntry.dateTaken = i.dateTaken
            complianceEntry.takenMedication = i.takenMedication

            do {
                try self.realm.write {
                    self.realm.add(complianceEntry, update: .all)
                    trackerCollectionView.reloadData()
                }
            } catch {
                print("Error saving context \(error)")
            }
        }
        //print(finalArray.description)
        countDaysTreated()
    }

    func countDaysTreated(){
        var count = 0

        for i in 0..<trackerData!.count {
            if trackerData![i].takenMedication == true {
                count += 1
            }
        }
        daysTreated = count
    }

}

extension TrackerVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyData.count
    }

}

extension TrackerVC: UICollectionViewDelegateFlowLayout {

    // - TODO: Correctly space collection view cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let numberOfCells = dummyData.count
        return CGSize(width: trackerCollectionView.bounds.size.width/CGFloat(numberOfCells+2), height: CGFloat(50))
    }

}

extension TrackerVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as! TrackerViewCell

        cell.trackerLabel.text = dummyData[indexPath.row]

        if finalTrackerData[indexPath.row].takenMedication == true {
            cell.trackerButton.isSelected = true
            cell.trackerButton.tintColor = UIColor.systemGreen
        } else {
            cell.trackerButton.isSelected = false
            cell.trackerButton.tintColor = UIColor.gray
        }

        let longDate = dateFormatter.string(from: finalTrackerData[indexPath.row].dateTaken!)
        let shortDate = String(longDate.prefix(3))
        cell.trackerLabel.text = shortDate
        cell.trackerButton.tag = indexPath.row
        cell.trackerButton.addTarget(self, action: #selector(treatmentButtonTapped), for: UIControl.Event.touchUpInside)

        return cell
    }

    @IBAction func treatmentButtonTapped(sender : UIButton){
        sender.isSelected = !sender.isSelected

        let complianceEntry = Compliance()

        let primaryKey = finalTrackerData[sender.tag].id
        let dateToEdit = finalTrackerData[sender.tag].dateTaken
        let currentTakenMedicationState = finalTrackerData[sender.tag].takenMedication
        let newTakenMedicationState = !currentTakenMedicationState

        complianceEntry.id = primaryKey
        complianceEntry.dateTaken = dateToEdit
        complianceEntry.takenMedication = newTakenMedicationState

        do {
            try self.realm.write {
                self.realm.add(complianceEntry, update: .all)
            }
        } catch {
            print("Error saving context \(error)")
        }

        countDaysTreated()
        resizeCircleView(by: daysTreated)
        trackerCollectionView.reloadData()
    }

}


