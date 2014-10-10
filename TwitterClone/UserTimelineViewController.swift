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

    var userTweets : [Tweet]?
    var twitterAccount : ACAccount?
    var networkController : TwitterService!
    
    var name : String?
    var userScreenName : String?
    var userLocation : String?
    var userAvatar : UIImage?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarImageViewUTVC: UIImageView!
    @IBOutlet weak var nameTextUTVC: UILabel!
    @IBOutlet weak var locationTextUTVC: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.setupNavBar()
        self.displayProfile()
        
        // Registering Nib file
        self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
        
        // Self-sizing cells
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Accessing AppDelegate
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        self.networkController.userScreenName = self.userScreenName
        
        // Fetch User Timeline from TwitterService (self.networkController -> appDelegate.networkController -> TwitterService)
        self.networkController.fetchUserTimeline { (errorDescription, tweets) -> (Void) in
            if errorDescription != nil {
                println("Uh oh.")
            } else {
                self.userTweets = tweets
                self.tableView.reloadData()
            }
        }
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
    
    // MARK: - Custom
    
    func setupNavBar() {
        // Navigation Bar Setup
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
