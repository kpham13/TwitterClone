//
//  HomeTimelineViewController.swift
//  TwitterClone
//
//  Created by Kevin Pham on 10/6/14.
//  Copyright (c) 2014 Kevin Pham. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UITableViewDataSource {

    var tweets : [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        
        if let path = NSBundle.mainBundle().pathForResource("tweet", ofType: "json") {
            var error : NSError? // Optional error variable
            let jsonData = NSData(contentsOfFile: path)
            
            self.tweets = Tweet.parseJSONDataIntoTweets(jsonData)
            println(self.tweets?)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return self.tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue the reusable cell
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        let tweet = self.tweets?[indexPath.row]
        cell.textLabel?.text = tweet?.text
        
        // Return the cell
        return cell
    }
}
