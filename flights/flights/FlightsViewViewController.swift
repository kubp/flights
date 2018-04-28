//
//  FlightsViewViewController.swift
//  flights
//
//  Created by user on 4/21/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

import Foundation

struct MyGitHub: Codable {
    
    let name: String?
    let location: String?
    let blog: URL?
    let followers: Int?
    let avatarUrl: URL?
    let repos: Int?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case location
        case blog
        case followers
        case repos = "public_repos"
        case avatarUrl = "avatar_url"
        
    }
}






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

    let singleton = searchResult.shared
    
    var animals: [String] = searchResult.shared.data


    @IBOutlet weak var button: UIButton!
    
    @IBAction func clicked(_ sender: Any) {
        searchResult.shared.data = ["Aaaa"]
        animals = ["sads"]
        
        
        print(searchResult.shared.data)
        FlightsTable?.reloadData()
        
        
        
        guard let gitUrl = URL(string: "https://api.github.com/users/kubp") else { return }
        
        URLSession.shared.dataTask(with: gitUrl) { (data, response
            , error) in
            
            guard let data = data else { return }
            do {
                
                let decoder = JSONDecoder()
                let gitData = try decoder.decode(MyGitHub.self, from: data)
                
                
                
                DispatchQueue.main.sync {
                    if let gimage = gitData.avatarUrl {
                        let data = try? Data(contentsOf: gimage)
                        let image: UIImage = UIImage(data: data!)!

                    }
                    
                    
                   print(gitData)
                }
                
            } catch let err {
                print("Err", err)
            }
            }.resume()
        
        
        

    }
    

    
    
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
