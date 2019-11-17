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
    //TODO: - Make an enumeration
    var sort: String = "oldest"

    @IBAction func historySortButton(_ sender: UIButton) {
        if sort == "newest" {
            categoryArray = categoryArray?.sorted(byKeyPath: "dateAdded", ascending: false)
            sort = "oldest"
            resultsHistory.reloadData()
            sender.setTitle("Newest", for: .normal)
        } else if sort == "oldest" {
            categoryArray = categoryArray?.sorted(byKeyPath: "dateAdded", ascending: true)
            sort = "newest"
            resultsHistory.reloadData()
            sender.setTitle("Oldest", for: .normal)
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryArray = realm.objects(Result.self).sorted(byKeyPath: "dateAdded", ascending: false)
        self.registerTableViewCells()
        resultsHistory.reloadData()
        resultsHistory.rowHeight = 90
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = UIColor(red: 138/255, green: 222/255, blue: 204/255, alpha: 1)
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
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
        //print("Array Count: \(String(describing: categoryArray?.count))")
        return categoryArray?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell

        if let category = categoryArray?[indexPath.row] {
            cell?.cellTitle.text = category.resultClassification
            cell?.cellSubTitle.text = String(format: "%.2f", category.resultAccuracy * 100) + "%"
            cell?.cellImage.image = UIImage(data: category.image as! Data)
            //cell?.cellImage.makeRounded()

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

extension UIImageView {

    func makeRounded() {
        self.layer.borderWidth = 0.5
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }

//    func maskCircle(anyImage: UIImage) {
//        self.contentMode = UIView.ContentMode.scaleAspectFill
//        self.layer.cornerRadius = self.frame.height / 2
//        self.layer.masksToBounds = false
//        self.clipsToBounds = true
//        self.image = anyImage
//    }
}
