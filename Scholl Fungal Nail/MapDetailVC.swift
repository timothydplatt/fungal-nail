//
//  MapDetailVC.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 18/11/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapDetailVC: UIViewController {

    var mapItem: MKMapItem?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!

    @IBAction func directionsButton(_ sender: UIButton) {

//        let options = [
//            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: mapItem?.placemark.region. regionSpan.center),
//            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
//        ]
        mapItem?.openInMaps(launchOptions: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let streetNumber = mapItem?.placemark.subThoroughfare ?? ""
        let streetName = mapItem?.placemark.thoroughfare

        titleLabel.text = mapItem?.name
        label1.text = "\(streetNumber) \(streetName!)"
        label2.text = mapItem?.placemark.locality
        label3.text = mapItem?.placemark.subLocality
        label4.text = mapItem?.placemark.postalCode
        label5.text = mapItem?.placemark.countryCode
        label6.text = mapItem?.phoneNumber
        label7.text = mapItem?.url?.absoluteString

        //        print(locationArray[indexPath.row]?.placemark.title)
        //        print(locationArray[indexPath.row]?.placemark.subtitle)
        //        print(locationArray[indexPath.row]?.name)
        //        print(locationArray[indexPath.row]?.placemark.coordinate)
        //        print(locationArray[indexPath.row]?.pointOfInterestCategory)
    }

    func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        if let title = title {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = title
            //mapView.addAnnotation(annotation)
        }
    }

}
