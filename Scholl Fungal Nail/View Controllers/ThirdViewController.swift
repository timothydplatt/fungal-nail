//
//  ThirdViewController.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 30/10/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ThirdViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func segmentControllerChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            searchString = "Pharmacy"
            locationArray.removeAll()
            searchInMap()
        //print("First Segment Selected")
        case 1:
            //print("Second Segment Selected")
            searchString = "Doctors"
            locationArray.removeAll()
            searchInMap()
        default:
            break
        }
    }
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 2000
    var previousLocation: CLLocation?
    var locationArray: [MKMapItem?] = []
    var searchString = "Pharmacy"
    var selectedMapItem: MKMapItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        checkLocationServices()
        searchInMap()
    }

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }

    func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centreViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }

    func centreViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }

    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude

        return CLLocation(latitude: latitude, longitude: longitude)
    }

    func searchInMap() {
        let request = MKLocalSearch.Request()
        print(searchString)
        request.naturalLanguageQuery = searchString

        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        request.region = MKCoordinateRegion(center: previousLocation!.coordinate, span: span)

        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            for item in response!.mapItems {
                self.locationArray.append(item)
                self.addPinToMapView(title: item.name, latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)

//                let x = self.locationArray.sorted { (MKMapItem1, MKMapItem2) -> Bool in
//                    Int((MKMapItem1?.placemark.location?.distance(from: self.previousLocation!))!) > Int((MKMapItem2?.placemark.location?.distance(from: self.previousLocation!))!)
//                }

                //                self.locationArray.sorted { (MKMapItem1, MKMapItem2) -> Bool in
                //                    MKMapItem1?.placemark.location?.distance(from: self.previousLocation) > MKMapItem2?.placemark.location?.distance(from: self.previousLocation)
                //                }
                //                self.locationArray.sorted { (MKMapItem1, MKMapItem2) -> Bool in
                //
                //                    let coordinateA = CLLocation(latitude: (MKMapItem1?.placemark.coordinate.latitude)!, longitude: (MKMapItem1?.placemark.coordinate.longitude)!)
                //
                //                    let coordinateB = CLLocation(latitude: (MKMapItem2?.placemark.coordinate.latitude)!, longitude: (MKMapItem2?.placemark.coordinate.longitude)!)
                //
                //                    let distFromCoordinateA = self.previousLocation?.distance(from: coordinateA)
                //                    let distFromCoordinateB = self.previousLocation?.distance(from: coordinateB)
                //
                //                    return Int(distFromCoordinateA!) > Int(distFromCoordinateB!)
            }

            self.tableView.reloadData()
        }
    }

    func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        if let title = title {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = title
            mapView.addAnnotation(annotation)
        }
    }

}

extension ThirdViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else { return }

        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }

}

extension ThirdViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

        let centre = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()

        guard let previousLocation = self.previousLocation else { return }

        guard centre.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = centre

        geoCoder.reverseGeocodeLocation(centre) { [weak self] (placemarks, error) in


            //guard case let self = self else { return }

            if let _ = error {
                //To do: Show alert information to the user.
            }

            guard let placemark = placemarks?.first else {
                //To do: Show alert information to the user.
                return
            }

//            let streetNumber = placemark.subThoroughfare ?? ""
//            let streetName = placemark.thoroughfare ?? ""

            //self?.addressLavel.text = "\(streetNumber) \(streetName)"

        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapDetail" {
            guard let viewController = segue.destination as? MapDetailVC else {
                return
            }
            viewController.mapItem = selectedMapItem
        }
    }

}

extension ThirdViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("Hello \(locationArray.count)")
        return locationArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0;//Choose your custom row height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as? LocationTableViewCell

        let coordinate1Lat = locationArray[indexPath.row]?.placemark.coordinate.latitude
        let coordinate1Long = locationArray[indexPath.row]?.placemark.coordinate.longitude
        let coordinate1 = CLLocation(latitude: coordinate1Lat!, longitude: coordinate1Long!)
        let coordinate2 = previousLocation
        let distanceInMeters = coordinate1.distance(from: coordinate2!)
        let distanceInKilometers = distanceInMeters/1000

        cell?.locationLabel.text = locationArray[indexPath.row]?.name
        cell?.phoneNumberLabel.text = String(Double(round(100*distanceInKilometers)/100)) + "KM"

        let streetNumber = locationArray[indexPath.row]?.placemark.subThoroughfare ?? ""
        let streetName = locationArray[indexPath.row]?.placemark.thoroughfare

        cell?.urlNumberLabel.text = "\(streetNumber) \(streetName!)"

        selectedMapItem = locationArray[indexPath.row]

//        locationArray[indexPath.row]?.openInMaps(launchOptions: [String : Any]?)
//        print(locationArray[indexPath.row]?.placemark.title)
//        print(locationArray[indexPath.row]?.placemark.subtitle)
//        print(locationArray[indexPath.row]?.name)
//        print(locationArray[indexPath.row]?.placemark.countryCode)
//        print(locationArray[indexPath.row]?.placemark.coordinate)
//        print(locationArray[indexPath.row]?.pointOfInterestCategory)
//        print(locationArray[indexPath.row]?.placemark.subThoroughfare)
//        print(locationArray[indexPath.row]?.placemark.thoroughfare)
//        print(locationArray[indexPath.row]?.placemark.locality)
//        print(locationArray[indexPath.row]?.placemark.subLocality)
//        print(locationArray[indexPath.row]?.placemark.postalCode)
//        print(locationArray[indexPath.row]?.url?.path)



//        print("Distance in meters: \(distanceInMeters)")

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "mapDetail", sender: nil)
        //print(indexPath.row)
    }
    
}
