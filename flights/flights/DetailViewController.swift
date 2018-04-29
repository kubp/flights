//
//  DetailViewController.swift
//  flights
//
//  Created by user on 4/19/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import MapKit
import Foundation


import CoreData

class DetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cityFrom: UILabel!
    @IBOutlet weak var dateFrom: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var cityTo: UILabel!
    @IBOutlet weak var dateTo: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBAction func favouritesClick(_ sender: Any) {
        self.saveToFavourites()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var passedValue: Flight? = nil
    
    
    let regionRadius: CLLocationDistance = 3000000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        
        if let cf = cityFrom {
            cf.text = passedValue?.cityFrom
        }
        
        if let ct = cityTo {
            ct.text = passedValue?.cityTo
        }
        
        if let cp = price {
            cp.text = String(passedValue?.price ?? 0) + " €"
        }

        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd-MMMM"
        let arrival = formatter.string(from: (passedValue?.aTime)!)
        let departure = formatter.string(from: (passedValue?.dTime)!)
        
        if let df = dateFrom {
            df.text = departure
        }
        if let da = dateTo {
            da.text = arrival
        }
        

        let initialLocation = CLLocation(latitude: 33.9424955, longitude: -118.4080684)
        
        centerMapOnLocation(location: initialLocation)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view, typically from a nib.
        
        let coords2 = CLLocationCoordinate2D(latitude: CLLocationDegrees(passedValue!.route[0].latFrom), longitude: CLLocationDegrees(passedValue!.route[0].lngFrom))
        
        var coordinates: [CLLocationCoordinate2D] = []
        for route in passedValue!.route {

            let LAX = CLLocation(latitude: CLLocationDegrees(route.latFrom), longitude: CLLocationDegrees(route.lngFrom))
            let JFK = CLLocation(latitude: CLLocationDegrees(route.latTo), longitude: CLLocationDegrees(route.lngTo))

         coordinates = coordinates + [LAX.coordinate, JFK.coordinate]

        }

        let geodesicPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: coordinates.count)
        
        mapView.add(geodesicPolyline)
        
        mapView.delegate = self
        
        mapView.centerCoordinate = coords2
        favouriteButton.layer.cornerRadius = 10; // this value vary as per your desire
        favouriteButton.clipsToBounds = true;
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //Return an `MKPolylineRenderer` for the `MKPolyline` in the `MKMapViewDelegate`s method
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.lineWidth = 3.0
            renderer.alpha = 0.5
            renderer.strokeColor = UIColor.blue
            return renderer
            
        }
        fatalError("Something wrong...")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func saveToFavourites(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Favourites", in: context)
        let newFligthData = NSManagedObject(entity: entity!, insertInto: context)
        
        newFligthData.setValue(passedValue?.cityFrom, forKey: "cityFrom")
        newFligthData.setValue(passedValue?.cityTo, forKey: "cityTo")
        newFligthData.setValue(passedValue?.aTime, forKey: "aTime")
        newFligthData.setValue(passedValue?.dTime, forKey: "dTime")
        newFligthData.setValue(passedValue?.price, forKey: "price")
        
        do {
            
            try context.save()
            
        } catch {
            print("Failed saving")
        }
    }
    
    var detailItem: Event? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    
}

