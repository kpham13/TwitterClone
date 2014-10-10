//
//  SingleTweetViewController.swift
//  TwitterClone
//
//  Created by Kevin Pham on 10/9/14.
//  Copyright (c) 2014 Kevin Pham. All rights reserved.
//

import UIKit

class SingleTweetViewController: UIViewController {

    var titleSTVC = "Tweet"
    var retweetText = "RETWEETS"
    var favoriteText = "FAVORITES"
    var selectedTweet : Tweet?
    
    @IBOutlet weak var avatarImageViewSTVC: UIImageView!
    @IBOutlet weak var nameTextSTVC: UILabel!
    @IBOutlet weak var userNameTextSTVC: UILabel!
    @IBOutlet weak var tweetTextSTVC: UILabel!
    @IBOutlet weak var timeLabelSTVC: UILabel!
    @IBOutlet weak var retweetCountLabelSTVC: UILabel!
    @IBOutlet weak var retweetLabelSTVC: UILabel!
    @IBOutlet weak var favoriteCountLabelSTVC: UILabel!
    @IBOutlet weak var favoriteLabelSTVC: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        self.displayTweet()
        
        // UIGestureRecognizer
        let imageSelect = UITapGestureRecognizer(target: self, action: NSSelectorFromString("imageTap"))
        self.avatarImageViewSTVC.addGestureRecognizer(imageSelect)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom

    func setupNavBar() {
        // Navigation Bar Setup
        var composeBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "composeTweet")
        self.title = self.titleSTVC
        self.navigationItem.rightBarButtonItem = composeBarButton
    }
    
    func displayTweet() {
        var retweetString = String(selectedTweet!.retweetCount)
        var favoriteString = String(selectedTweet!.favoriteCount)
        
        self.retweetLabelSTVC.text = self.retweetText
        self.favoriteLabelSTVC.text = self.favoriteText
        
        self.avatarImageViewSTVC.layer.cornerRadius = self.avatarImageViewSTVC.frame.size.width / 6 // 2=Circle, 3,4,5=RoundedCorners, 10=
        self.avatarImageViewSTVC.clipsToBounds = true
        self.avatarImageViewSTVC.layer.borderWidth = 3.0
        self.avatarImageViewSTVC.layer.borderColor = UIColor.whiteColor().CGColor
        self.avatarImageViewSTVC.image = self.selectedTweet!.avatarImage
        
        self.nameTextSTVC.text = self.selectedTweet!.name
        self.userNameTextSTVC.text = "@" + self.selectedTweet!.screenName
        self.tweetTextSTVC.text = self.selectedTweet!.text
        self.retweetCountLabelSTVC.text = retweetString
        self.favoriteCountLabelSTVC.text = favoriteString
    }
    
    func imageTap() {
        let userVC = self.storyboard?.instantiateViewControllerWithIdentifier("USER_TIMELINE_VC") as UserTimelineViewController
        // var location = self.selectedTweet!.userDictionary["location"] as? String
        
        userVC.name = self.selectedTweet!.name
        userVC.userScreenName = self.selectedTweet!.screenName
        userVC.userLocation = self.selectedTweet!.userDictionary["location"] as? String
        userVC.userAvatar = self.selectedTweet!.avatarImage
        
        self.navigationController?.pushViewController(userVC, animated: true)
    }
    
    func composeTweet() {
        // Compose Tweet
    }
}
