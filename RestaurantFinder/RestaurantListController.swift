//
//  MasterViewController.swift
//  RestaurantFinder
//
//  Created by Pasan Premaratne on 5/4/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

class RestaurantListController: UITableViewController {
    
    let coordinate = Coordinate(latitude: 40.759106, longitude:  -73.985185)
    let foursquareClient = FoursquareClient(clientID: "BASIYY5STZI0U3C0EWGAASR4MFYU10BSF5P1NK4LCZECELY0", clientSecret: "YRPQKN4Y4TICTQZ3N3AKG0ERQEZX3K3BKDSX1ECMDWLW2UGP")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        foursquareClient.fetchRestaurantsFor(coordinate, category: .Food(nil)) { result in
            switch result {
            case .Success(let venues):
                print(venues)
            case .Failure(let error):
                print(error)
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

}

