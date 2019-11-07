//
//  ResultsVC.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 04/11/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import UIKit
import CoreML
import Vision
import RealmSwift

class ResultsVC: UIViewController {

    let realm = try! Realm()

//    lazy var realm:Realm = {
//        return try! Realm()
//    }()

    var resultImage: UIImage?

    @IBOutlet weak var imageResult: UIImageView!
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var resultAccuracy: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        imageResult.image = resultImage

        guard let ciImage = CIImage(image: resultImage!) else {
            fatalError("Couldn't convert UIImage to CIImage")
        }
        detect(image: ciImage)
    }

    //Classify image.
    func detect(image: CIImage) {

        guard let model = try? VNCoreMLModel(for: MyImageClassifier2_1().model) else {
            fatalError("Loading CoreML model failed")
        }

        let request = VNCoreMLRequest(model: model) { (request, error) in

            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }

            guard let accuracy = results.first?.confidence else {
                fatalError()
            }

            self.resultTitle.text = results.first?.identifier
            self.resultAccuracy.text = String(accuracy * 100)

            let x = self.realm.objects(Result.self).sorted(byKeyPath: "id", ascending: false)[0]
            let highest = x.id

            let result = Result()
            result.id = highest + 1
            result.resultClassification = results.first!.identifier
            result.resultAccuracy = accuracy
            result.dateAdded = Date()

            guard let image = self.resultImage else { return }
            //let data = NSData(data: image.jpegData(compressionQuality: 0.9)!)
            let data = NSData(data: image.pngData()!)
            result.image = data

            do {
                try self.realm.write {
                    self.realm.add(result)
                }
            } catch {
                print("Error saving context \(error)")
            }
        }

        let handler = VNImageRequestHandler(ciImage: image)

        do {
            try! handler.perform([request])
        }
        catch {
            print(error)
        }
    }

}
