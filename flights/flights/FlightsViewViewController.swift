//
//  FlightsViewViewController.swift
//  flights
//
//  Created by user on 4/21/18.
//  Copyright © 2018 user. All rights reserved.
//
import UIKit
import Foundation
import CoreData
import MapKit
import CoreLocation

struct FlightsApi: Decodable {
    let currency: String
    let data: [FlightData]
    // let route: [Route]
    
    enum CodingKeys : String, CodingKey {
        case currency
        case data = "data"
        // case route = "route"
    }
}

struct RouteData: Decodable {
    let latFrom: Float
    let lngTo: Float
    let latTo: Float
    let lngFrom: Float
}

struct FlightData: Decodable {
    let mapIdfrom: String
    let flyFrom: String
    let fly_duration: String
    let flyTo: String
    let aTime: Date
    let dTime: Date
    let price: Int
    let cityFrom: String
    let cityTo: String
    
    let route: [RouteData]
}



class FLightCell: UITableViewCell{
    @IBOutlet weak var dateFrom: UILabel!
    @IBOutlet weak var cityFrom: UILabel!
    @IBOutlet weak var dateTo: UILabel!
    @IBOutlet weak var cityTo: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var price: UILabel!

  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}

class FlightsViewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate  {
    @IBOutlet weak var searchTextField: UITextField!
    
    let singleton = searchResult.shared
    var tableFlights: [Flight] = []
    
    let locationManager = CLLocationManager() // Add this statement
    
    var coordinates: CLLocationCoordinate2D? =  CLLocationCoordinate2D(latitude: CLLocationDegrees(50), longitude: CLLocationDegrees(14))
    
    
    @IBAction func searchFlightsAction(_ sender: Any) {
        let text: String = searchTextField.text!
        print(text)
        loadFLightsFromApi(to: text)
    
    }
    
    func loadFLightsFromApi(to: String = "anywhere"){

        
        let lat : NSNumber = NSNumber(value: self.coordinates!.latitude)
        let lng : NSNumber = NSNumber(value: self.coordinates!.longitude)
        
        //Store it into Dictionary
        let apiLat = String(describing: lat)
        let apiLng = String(describing: lng)
        
        let apiCoordinates = apiLat + "-" + apiLng + "-250km"
        print(apiCoordinates)
        
        guard let gitUrl = URL(string: "https://api.skypicker.com/flights?adults=1&affilid=stories&asc=1&children=0&dateFrom=28%2F04%2F2018&dateTo=28%2F06%2F2018&daysInDestinationFrom=2&daysInDestinationTo=10&featureName=results&flyFrom="+apiCoordinates+"&infants=0&limit=60&locale=us&offset=0&one_per_date=0&oneforcity=0&partner=skypicker&returnFrom=&returnTo=&sort=quality&to="+to+"&typeFlight=return&v=3&wait_for_refresh=0") else { return }
        
        
        URLSession.shared.dataTask(with: gitUrl) { (data, response
            , error) in
            
            guard let data = data else { return }
            do {
                
                guard let fligtsData = try? JSONDecoder().decode(FlightsApi.self, from: data) else {
                    print("Error: Couldn't decode data into Blog")
                    return
                }
                
                var allFlights:[Flight] = []
                
                for flight in fligtsData.data {
                    
                    var routes: [Route] = []
                    for route in  flight.route {
                        routes = routes + [Route(latFrom: route.latFrom,
                                                 lngTo: route.lngTo,
                                                 latTo: route.latTo,
                                                 lngFrom: route.lngFrom
                            )]
                    }
                    
                    let flight = Flight(mapIdfrom: flight.mapIdfrom,
                                        flyFrom: flight.flyFrom,
                                        fly_duration: flight.fly_duration,
                                        flyTo: flight.flyTo,
                                        aTime: flight.aTime,
                                        dTime: flight.dTime,
                                        price: flight.price,
                                        cityFrom: flight.cityFrom,
                                        cityTo: flight.cityTo,
                                        route: routes)
                    
                    allFlights = allFlights + [flight]
                    
                }
                
                
                DispatchQueue.main.sync {
                    searchResult.shared.data = allFlights
                    
                    self.tableFlights = allFlights
                    self.FlightsTable?.reloadData()
                }
                
            } catch let err {
                print("Err", err)
            }
            }.resume()
        
        
        self.FlightsTable?.reloadData()
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FLightCell
        cell.backgroundColor = UIColor.clear
  
        let formatter = DateFormatter()

        formatter.dateFormat = "dd-MMMM"
        let arrival = formatter.string(from: tableFlights[indexPath.row].aTime)
        let departure = formatter.string(from: tableFlights[indexPath.row].dTime)
        
        
        cell.cityFrom.text = tableFlights[indexPath.row].cityFrom
        cell.cityTo.text = tableFlights[indexPath.row].cityTo
        cell.dateFrom.text = departure
        cell.dateTo.text = arrival
        
        cell.duration.text = tableFlights[indexPath.row].fly_duration
        cell.price.text = String(tableFlights[indexPath.row].price) + "€"

        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableFlights.count
    }
    


    @IBOutlet weak var FlightsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        searchTextField.borderStyle = .roundedRect;
        searchTextField.backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchTextField.layer.cornerRadius=8.0
        
        loadFLightsFromApi()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.coordinates = location.coordinate
        
        loadFLightsFromApi()
    }
    
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if(segue.identifier == "detailSegue"){
            let row = FlightsTable.indexPathForSelectedRow?.row

            let navVC = segue.destination as? UINavigationController
            let destinationVC = navVC?.viewControllers.first as! DetailViewController
            
            destinationVC.passedValue = self.tableFlights[row!]
            
        }
        
        
    }
    

}
