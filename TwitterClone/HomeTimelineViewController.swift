//
//  HomeTimelineViewController.swift
//  TwitterClone
//
//  Created by Kevin Pham on 10/6/14.
//  Copyright (c) 2014 Kevin Pham. All rights reserved.
//

import UIKit
import Accounts
import Social

class HomeTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets : [Tweet]?
    var twitterAccount : ACAccount?
    var networkController : TwitterService!
    
    var imageDownloadQueue = NSOperationQueue()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self // Provides Data
        self.tableView.delegate = self // Provides User Interaction
        
        // Self sizing cells - set the rowHeight of your table view to UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Accessing AppDelegate
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController // Assigning networkController from AppDelegate
        
        // Fetch Home Timeline from TwitterService (self.networkController -> appDelegate.networkController -> TwitterService)
        self.networkController.fetchHomeTimeline { (errorDescription, tweets) -> Void in
            if errorDescription != nil {
                // Alert the user that something went wrong here or log errors,
            } else {
                // Request Successful!
                self.tweets = tweets
                self.tableView.reloadData()
            }
        }
        
        /* // Parsing Local JSON File
        if let path = NSBundle.mainBundle().pathForResource("tweet", ofType: "json") {
            var error : NSError? // Optional error variable
            let jsonData = NSData(contentsOfFile: path)
            
            self.tweets = Tweet.parseJSONDataIntoTweets(jsonData)
        }
        */
    }
    
    override func viewDidAppear(animated: Bool) {
        //
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return self.tweets!.count
        } else {
            return 0
        }
    }
    
    /*
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120.0
    }
    */
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 1. Dequeue Reusable Cell using TweetCell Custom Cell Class
        let cell: TweetCell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
        
        // * Sort *
        // var sortedTweets = tweets?.sorted { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
        
        // 2.0 Configure Cell...
        let tweet = self.tweets?[indexPath.row]
        
        // 2.1 Tweet Labels
        var userName = tweet!.userDictionary["screen_name"] as? String
        cell.nameText.text = tweet!.userDictionary["name"] as? String
        cell.userNameText.text = "@" + userName!
        cell.tweetText.text = tweet?.text

        // 2.2 Avatar ImageView Rounded Corners
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.size.width / 6 // 2=Circle, 3,4,5=RoundedCorners, 10=
        cell.avatarImageView.clipsToBounds = true
        cell.avatarImageView.layer.borderWidth = 3.0
        cell.avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        // 2.3 NSOperations - Avatar Image
        var downloadOperation = NSBlockOperation { () -> Void in
            let avatarURLString = tweet!.userDictionary["profile_image_url"] as String
            let avatarURL = NSURL(string: avatarURLString)
            let avatarData = NSData(contentsOfURL: avatarURL)
            let avatarImage = UIImage(data: avatarData)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                cell.avatarImageView.image = avatarImage
                // self.imageActivity.stopAnimating()
            })
        }
        
        // downloadOperation.qualityOfService = NSQualityOfService.Background
        self.imageDownloadQueue.addOperation(downloadOperation)
        
        // 3. Return Cell
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
