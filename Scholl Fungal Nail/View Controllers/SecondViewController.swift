//
//  SecondViewController.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 30/10/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import UIKit
import RealmSwift

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var resultsHistory: UITableView!

    let realm = try! Realm()
    var categoryArray: Results<Result>?

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryArray = realm.objects(Result.self)
        self.registerTableViewCells()
        resultsHistory.reloadData()
        resultsHistory.rowHeight = 90
    }

    override func viewWillAppear(_ animated: Bool) {
        resultsHistory.reloadData()
    }

    func registerTableViewCells(){
        let textFieldCell = UINib(nibName: "CustomTableViewCell", bundle: nil)
        self.resultsHistory.register(textFieldCell, forCellReuseIdentifier: "CustomTableViewCell")
    }

    //MARK: - TableView Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Array Count: \(String(describing: categoryArray?.count))")
        return categoryArray?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell

        if let category = categoryArray?[indexPath.row] {
            //cell?.cellImage = category.res
            cell?.cellTitle.text = category.resultClassification
            cell?.cellSubTitle.text = String(category.resultAccuracy)
            cell?.cellImage.image = UIImage(data: category.image as! Data)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            var newDate = dateFormatter.string(from: category.dateAdded ?? Date())
            cell?.cellDate.text = newDate
            //cell.textLabel?.text = category.resultClassification ?? "No classification added yet."

        }

        return cell!
    }


//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//
//        let cell = tableView(tableView, cellForRowAt: indexPath)
//
//        if let category = categoryArray?[indexPath.row] {
//
//            cell.textLabel?.text = category.name ?? "No categories added yet."
//
//            guard let categoryColour = UIColor(hexString: category.colour ?? "1D9BF6") else { fatalError()}
//
//            cell.backgroundColor = categoryColour
//
//            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
//
//        }
//
//        return cell
//    }

}

