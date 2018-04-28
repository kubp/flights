//
//  FlightsViewViewController.swift
//  flights
//
//  Created by user on 4/21/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit


class FLightCell: UITableViewCell{

    @IBOutlet weak var label: UILabel!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 20, 0, 20))
    }
    
    @IBOutlet weak var tableView: UITableView!
}

class FlightsViewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {


    let animals = ["cast", "sadsd"]
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FLightCell
        cell.backgroundColor = UIColor.clear
        cell.label.text = animals[indexPath.row]

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }
    


    @IBOutlet weak var FlightsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var passedValue = FlightsTable.indexPathForSelectedRow?.row
        
        let destinationVC = segue.destination as! DetailViewController
        destinationVC.passedValue = "ads"
        
        
    }
    

}
