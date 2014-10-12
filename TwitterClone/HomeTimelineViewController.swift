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

class HomeTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIApplicationDelegate {
    
    var titleHTVC = "Home"
    
    var tweets : [Tweet]?
    //var imageCache = [String : UIImage]()
    var twitterAccount : ACAccount?
    var networkController : TwitterService!
    var refreshControl : UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self // Provides Data
        self.tableView.delegate = self // Provides User Interaction
        self.setupNavBar()
        
        // Tab Bar
//        let tabBar = self.tabBar
//        let tabItems = tabBar.items as [UITabBarItem]
//        tabItems[0].title = "Timelines"
        //tabItems[1].title = "Notifications"
        //tabItems[2].title = "Messages"
        //tabItems[3].title = "Me"
        
        // Registering Nib file
        self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
        
        // Self sizing cells - set the rowHeight of your table view to UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Accessing AppDelegate
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController // Assigning networkController from AppDelegate
        
        self.networkController.fetchHomeTimeline { (errorDescription, tweets) -> (Void) in
            if errorDescription != nil {
                // Alert the user that something went wrong here or log errors.
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
        
        // Initialize Refresh function
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        self.refreshControl.addTarget(self, action: "refreshTimeline:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl) // Adding Refresh to Subview
    }
    
    override func viewDidAppear(animated: Bool) {
        // Dynamic Cell Height
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
        
        //var userName = tweet!.userDictionary["screen_name"] as? String
        var retweetString = String(tweet!.retweetCount)
        var favoriteString = String(tweet!.favoriteCount)
        
        // 2.1 Tweet Labels
        cell.nameText.text = tweet!.name
        cell.userNameText.text = "@" + tweet!.screenName
        cell.tweetText.text = tweet?.text

        // 2.2 Avatar ImageView Rounded Corners
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.size.width / 6 // 2=Circle, 3,4,5=RoundedCorners, 10=
        cell.avatarImageView.clipsToBounds = true
        cell.avatarImageView.layer.borderWidth = 3.0
        cell.avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        // 2.3 NSOperations - Avatar Image
        if tweet?.avatarImage != nil {
            // If avatarImage does exist, set avatarImageView
            cell.avatarImageView.image = tweet?.avatarImage
        } else {
            // Download user image
            self.networkController.downloadUserImage(tweet!, completionHandler: { (image) -> (Void) in
                let cellForImage = self.tableView.cellForRowAtIndexPath(indexPath) as TweetCell?
                cellForImage?.avatarImageView.image = image
                // Store the image in to our cache
                // self.imageCache[urlString] = image
            })
        }
        
        // 2.4 Twitter Actions
        cell.replyImageView.image = cell.replyIcon
        cell.retweetImageView.image = cell.retweetIcon
        cell.favoriteImageView.image = cell.favoriteIcon
        cell.retweetCountLabel.text = retweetString
        cell.favoriteCountLabel.text = favoriteString

        // 3. Return Cell
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let newVC = self.storyboard?.instantiateViewControllerWithIdentifier("SINGLE_TWEET_VC") as SingleTweetViewController
        //newVC.view.backgroundColor = UIColor.redColor()
        //newVC.countLabel.text = "sdofijsdoifj"
        var tweetForRow = self.tweets?[indexPath.row]
        newVC.selectedTweet = tweetForRow
        
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    // Refresh Timeline (since_id)
    func refreshTimeline(sender: AnyObject) {
        var updatedTweets = [Tweet]()
        var tweet = self.tweets?[0]
        var tweetID = tweet?.id
        println(tweet?.name)
        
        self.networkController.refreshHomeTimeline(tweetID!) { (errorDescription, tweets) -> (Void) in
            if errorDescription != nil {
                // Alert the user that something went wrong here or log errors.
            } else {
                // Request Successful!
                updatedTweets = tweets!
                //self.tweets?.insert(updatedTweets, atIndex: 0) // NSArray not a Subtype of 'Tweet' error
                //self.tweets?.append(updatedTweets)
                println(updatedTweets.count)
                println(updatedTweets)
                switch updatedTweets.count {
                case 0:
                    println("No new updates")
                default:
                    println("Updating...")
                    for newTweetIndex in 0...(updatedTweets.count-1) {
                        var newTweet = updatedTweets[newTweetIndex]
                        self.tweets?.insert(newTweet, atIndex: newTweetIndex)
                        println("Appended")
                    }
                    
                    self.tableView.reloadData()
                }
            }
            
            self.refreshControl.endRefreshing()
        }
    }
    
    // Infinite Scrolling (max_id)
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        var updatedTweets = [Tweet]()
        var tableCount = tweets?.count
        
        if (tableCount!-20) == indexPath.row {
            var tweet = self.tweets?.last
            var tweetID = tweet?.id
            var tweetMaxID = tweetID! - 1
            
            self.networkController.scrollHomeTimeline(tweetMaxID, completionHandler: { (errorDescription, tweets) -> (Void) in
                if errorDescription != nil {
                    // Alert the user that something went wrong here or log errors.
                } else {
                    updatedTweets = tweets!
                    switch updatedTweets.count {
                    case 0:
                        println("No new updates")
                    default:
                        println("Updating...")
                        for newTweetIndex in 0...(updatedTweets.count-1) {
                            var newTweet = updatedTweets[newTweetIndex]
                            self.tweets?.append(newTweet)
                        }
                        
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
    
    // MARK: - Custom
    
    // Navigation Bar Setup
    func setupNavBar() {
        var composeBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "composeTweet")
        self.title = self.titleHTVC
        self.navigationItem.rightBarButtonItem = composeBarButton
    }
    
    func composeTweet() {
        // Compose Tweet
    }
}
