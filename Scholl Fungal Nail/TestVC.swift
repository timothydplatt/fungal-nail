//
//  TestVC.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 13/11/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import UIKit

class TestVC: UIViewController {

    var parentViewWdith: CGFloat?
    var number: Int?
    var initialCenterX: CGFloat?
    var initialCenterY: CGFloat?
    var initialOriginX: CGFloat?
    var initialOriginY: CGFloat?
    var initalCircleViewWidth: CGFloat?

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var circleWidth: NSLayoutConstraint!
    @IBOutlet weak var circleHeight: NSLayoutConstraint!

    @IBAction func button(_ sender: UIButton) {
        number! += 1
        animation(number!)
        //pulse(CGFloat(number!))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        parentViewWdith = self.view.frame.size.width
        number = 1
        initialCenterX = circleView.center.x
        initialCenterY = circleView.center.y
        initialOriginX = circleView.frame.origin.x
        initialOriginY = circleView.frame.origin.y
        initalCircleViewWidth = circleView.frame.size.width

        //circleView.center = self.view.center
        circleView.layer.cornerRadius = circleView.frame.width/2
        circleView.clipsToBounds = true
        circleView.layer.allowsEdgeAntialiasing = true
        circleView.translatesAutoresizingMaskIntoConstraints = false
    }

//    func pulse(_ multipler: CGFloat) {
//        print(initalCircleViewWidth!)
//        print(parentViewWdith!)
//        var scaleXAmount = (initalCircleViewWidth!/parentViewWdith!)*multipler
//        var scaleYAmount = (initalCircleViewWidth!/parentViewWdith!)*multipler
//
//        print(scaleXAmount)
//
//        UIView.animate(withDuration: 0.5, animations:{
//            self.circleView.transform = CGAffineTransform(scaleX: CGFloat(1+scaleXAmount), y: CGFloat(1+scaleYAmount))
//        }, completion: { _ in
//        })
//    }

    func animation(_ multipler: Int){

        circleWidth.constant = (parentViewWdith!/7)*(CGFloat(multipler*2))
        circleHeight.constant = (parentViewWdith!/7)*(CGFloat(multipler*2))

//        circleView.frame.origin.x = initialOriginX!
//        circleView.frame.origin.y = initialOriginY!
//        circleView.center.x = initialCenterX!
//        circleView.center.y = initialCenterY!

        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.view.layoutIfNeeded()
        },
                       completion: { finished in
        })

        //animate cornerRadius and update model
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.duration = 1.0
        //super important must match
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animation.fromValue = circleView.layer.cornerRadius
        animation.toValue = ((parentViewWdith!/7)*CGFloat(multipler))
        circleView.layer.add(animation, forKey: nil)
        //update model important
        circleView.layer.cornerRadius = ((parentViewWdith!/7)*CGFloat(multipler))
    }

}
