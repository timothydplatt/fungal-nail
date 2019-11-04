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

class ResultsVC: UIViewController {

    var resultImage: UIImage?

    @IBOutlet weak var imageResult: UIImageView!
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var resultAccuracy: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

//            for r in results{
//                let percent = Int(r.confidence * 100)
//                print("\(r.identifier) \(percent)%")
//            }

            self.resultTitle.text = results.first?.identifier
            self.resultAccuracy.text = String(accuracy * 100)
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
