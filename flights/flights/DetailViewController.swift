//
//  DetailViewController.swift
//  flights
//
//  Created by user on 4/19/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var flightName: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
     var passedValue: String = "Anonymous"
    

    func configureView() {
        // Update the user interface for the detail item.

            if let label = flightName {
                label.text = passedValue
            }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Event? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

