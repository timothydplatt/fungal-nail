//
//  FourthViewController.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 30/10/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import UIKit

class FourthViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let productName = ["Product 1", "Product 2", "Product 3"]
    let productImages = [UIImage(named: "1"),UIImage(named: "2"),UIImage(named: "3")]
    let productDescription = ["Product 1 long description text as an example for the prototype", "Product 2 long description text as an example for the prototype","Product 3 long description text as an example for the prototype"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productName.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CustomCollectionViewCell

        cell.productImage.image = productImages[indexPath.row]
        cell.productTitle.text = productName[indexPath.row]
        cell.productDescription.text = productDescription[indexPath.row]

        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath

        return cell
    }
}
