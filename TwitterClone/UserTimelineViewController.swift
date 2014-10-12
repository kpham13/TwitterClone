//
//  UserTimelineViewController.swift
//  TwitterClone
//
//  Created by Kevin Pham on 10/9/14.
//  Copyright (c) 2014 Kevin Pham. All rights reserved.
//

import UIKit
import Accounts
import Social

class UserTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIApplicationDelegate {

    var twitterAccount : ACAccount?
    var networkController : TwitterService!
    var refreshControl : UIRefreshControl!

    var userTweets : [Tweet]?
    var name : String?
    var userScreenName : String?
    var userLocation : String?
    var userAvatar : UIImage?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var avatarImageViewUTVC: UIImageView!
    @IBOutlet weak var nameTextUTVC: UILabel!
    @IBOutlet weak var locationTextUTVC: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.setupNavBar()
        self.displayProfile()
        
//        // Tab Bar
//        let tabBar = self.tabBar
//        let tabItems = tabBar.items as [UITabBarItem]
//        tabItems[0].title = "Timelines"
//        tabItems[1].title = "Notifications"
//        tabItems[2].title = "Messages"
//        tabItems[3].title = "Me"
        
        // Registering Nib file
        self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
        
        // Self-sizing cells
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Accessing AppDelegate
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        
        // Fetch User Timeline from TwitterService (self.networkController -> appDelegate.networkController -> TwitterService)
        self.networkController.fetchUserTimeline(self.userScreenName!) { (errorDescription, tweets) -> (Void) in
            if errorDescription != nil {
                println("Uh oh.")
            } else {
                self.userTweets = tweets
                self.tableView.reloadData()
            }
        }
        
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
        if self.userTweets != nil {
            return self.userTweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 1. Dequeue Reusable Cell using TweetCell Custom Cell Class
        let cell: TweetCell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
        
        // 2.0 Configure Cell...
        let tweet = self.userTweets?[indexPath.row]

        var retweetString = String(tweet!.retweetCount)
        var favoriteString = String(tweet!.favoriteCount)

        // 2.1 Tweet Labels
        cell.nameText.text = tweet!.userDictionary["name"] as? String
        cell.userNameText.text = "@" + tweet!.screenName
        cell.tweetText.text = tweet?.text
        
        // 2.2 Avatar ImageView Rounded Corners
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.size.width / 6
        cell.avatarImageView.clipsToBounds = true
        cell.avatarImageView.layer.borderWidth = 3.0
        cell.avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        // 2.3 NSOperations - Avatar Image
        if tweet?.avatarImage != nil {
            cell.avatarImageView.image = tweet?.avatarImage
        } else {
            self.networkController.downloadUserImage(tweet!, completionHandler: { (image) -> (Void) in
                let cellForImage = self.tableView.cellForRowAtIndexPath(indexPath) as TweetCell?
                cellForImage?.avatarImageView.image = image
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
        var tweetForRow = self.userTweets?[indexPath.row]
        newVC.selectedTweet = tweetForRow
        
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    // Refresh Timeline (since_id)
    func refreshTimeline(sender: AnyObject) {
        var updatedTweets = [Tweet]()
        var tweet = self.userTweets?[0]
        var tweetID = tweet?.id
        //println(tweet?.name)
        
        self.networkController.refreshUserTimeline(self.userScreenName!, tweetID: tweetID!) { (errorDescription, tweets) -> (Void) in
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
                        self.userTweets?.insert(newTweet, atIndex: newTweetIndex)
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
        var tableCount = userTweets?.count
        
        if (tableCount!-20) == indexPath.row {
            var tweet = self.userTweets?.last
            var tweetID = tweet?.id
            var tweetMaxID = tweetID! - 1
            
            self.networkController.scrollUserTimeline(self.userScreenName!, tweetID: tweetMaxID, completionHandler: { (errorDescription, tweets) -> (Void) in
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
                            self.userTweets?.append(newTweet)
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
        // self.title = self.name
        self.navigationItem.rightBarButtonItem = composeBarButton
        // self.navigationController?.navigationBarHidden = true
        self.navigationController?.navigationBar.translucent = true
    }
    
    func displayProfile() {
        self.avatarImageViewUTVC.layer.cornerRadius = self.avatarImageViewUTVC.frame.size.width / 6
        self.avatarImageViewUTVC.clipsToBounds = true
        self.avatarImageViewUTVC.layer.borderWidth = 3.0
        self.avatarImageViewUTVC.layer.borderColor = UIColor.whiteColor().CGColor
        self.avatarImageViewUTVC.image = self.userAvatar
        
        self.nameTextUTVC.text = self.name
        self.locationTextUTVC.text = self.userLocation
    }
    
    func composeTweet() {
        // Compose Tweet
    }
}
