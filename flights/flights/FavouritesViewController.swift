//
//  FavouritesViewController.swift
//  flights
//
//  Created by user on 4/28/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CoreData


class FavouritesViewController: UITableViewController {
var people: [NSManagedObject] = []
   
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let from = people[indexPath.row].value(forKey: "cityFrom") as? String
        let to = people[indexPath.row].value(forKey: "cityTo") as? String
        let price = people[indexPath.row].value(forKey: "price") as? Int
        
        cell.textLabel?.text = from! + " → " + to!
        
        cell.detailTextLabel?.text = String(price!) + " €"
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        if editingStyle == .delete {
            let commit = people[indexPath.row]
            appDelegate.persistentContainer.viewContext.delete(commit)
            people.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
             appDelegate.saveContext()
        }
    }
    
    
    // MARK: - Table view data source



    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Favourites")
        
        
        do {
            let result = try managedContext.fetch(fetchRequest)
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
        
        //3
        do {
            
            self.people = try managedContext.fetch(fetchRequest)
         
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    

}
