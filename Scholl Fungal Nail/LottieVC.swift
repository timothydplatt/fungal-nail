//
//  LottieVC.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 13/11/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import UIKit
import Lottie

class LottieVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let animationView = AnimationView(name: "1798-check-animation")
            animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
            animationView.center = self.view.center
            animationView.contentMode = .scaleAspectFill

            view.addSubview(animationView)

            animationView.play()

    }


}
