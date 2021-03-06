//
//  CompareVC.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 05/11/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import UIKit
import RealmSwift

class CompareVC: UIViewController {

    var bottomImage: UIImage?
    let realm = try! Realm()
//    lazy var realm: Realm = {
//            return try! Realm()
//        }()
    var categoryArray: Results<Result>?

    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var topFootImage: UIImageView!
    @IBOutlet weak var bottomFootImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryArray = realm.objects(Result.self)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let bottomImage = UIImage(data: categoryArray?.last?.image as! Data)
        let topImage = UIImage(data: categoryArray?.first?.image as! Data)

        bottomImageView.image = bottomImage
        topImageView.image = topImage

        topFootImage.setImageColor(color: (topImage?.averageColor)!)
        bottomFootImage.setImageColor(color: (bottomImage?.averageColor)!)
    }
    
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
