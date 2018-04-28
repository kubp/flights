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
      //  contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 20, 0, 20))
    }
    
    @IBOutlet weak var tableView: UITableView!
}

class FlightsViewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    let singleton = searchResult.shared
    
    var tableFlights: [Flight] = []
    
 

    @IBOutlet weak var button: UIButton!
    
    @IBAction func clicked(_ sender: Any) {

        saveToFavourites()
        
        
        guard let gitUrl = URL(string: "https://api.skypicker.com/flights?flyFrom=PRG&to=&dateFrom=18/06/2018&dateTo=25/06/2018") else { return }
        
        URLSession.shared.dataTask(with: gitUrl) { (data, response
            , error) in
            
            guard let data = data else { return }
            do {
                
                let decoder = JSONDecoder()
           
                guard let blog = try? JSONDecoder().decode(FlightsApi.self, from: data) else {
                    print("Error: Couldn't decode data into Blog")
                    return
                }
                
                print("blog title: \(blog.currency)")
                
                var allFlights:[Flight] = []
                
                for article in blog.data {
                    
                        
                    let flight = Flight(mapIdfrom: article.mapIdfrom, flyFrom: article.flyFrom, fly_duration: article.fly_duration, flyTo: article.flyTo, aTime: article.aTime, dTime: article.dTime, price: article.price, cityFrom: article.cityFrom, cityTo: article.cityTo, route: [Route(latFrom: article.route[0].latFrom, lngTo: article.route[0].lngTo, latTo: article.route[0].latTo, lngFrom: article.route[0].lngFrom)])
                    
                    allFlights = allFlights + [flight]
                    
                    
            
                }
                
                
                DispatchQueue.main.sync {
                    searchResult.shared.data = allFlights
                    //animals = ["sads"]
                    
                    self.tableFlights = allFlights
                    self.FlightsTable?.reloadData()
                }
                //print(searchResult.shared.data)
               
                
                
    
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
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd"
        
        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
    
        formatter.dateFormat = "dd-MMMM"
        // again convert your date to string
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
    
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func saveToFavourites(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
       
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
//        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false



        // Create Batch Delete Request
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
//
//        do {
//            try context.execute(batchDeleteRequest)
//
//        } catch {
//            // Error Handling
//        }

        
        do {
            let result = try context.fetch(request)
            let f = result as! [NSManagedObject]
            
            print(f)
            
            for data in result as! [NSManagedObject] {
                let a = data.value(forKey: "cityFrom") as! String
                print(a)
                print(data.value(forKey: "cityFrom") as! String)
            }
            
        } catch {
            
            print("Failed")
        }

    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if(segue.identifier == "detailSegue"){
            let row = FlightsTable.indexPathForSelectedRow?.row
            
            
            print(self.tableFlights[row!])
            
            
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.passedValue = self.tableFlights[row!]
            
        }

        if(segue.identifier == "favouritesSegue"){
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//            let context = appDelegate.persistentContainer.viewContext
//
//            let destinationVC = segue.destination as! FavouritesViewController
//
//            print(destinationVC)
         //   destinationVC.context = context
        }
        
        
    }
    

}
