//
//  Tweet.swift
//  TwitterClone
//
//  Created by Kevin Pham on 10/6/14.
//  Copyright (c) 2014 Kevin Pham. All rights reserved.
//

import UIKit

// Model Class According to JSON
class Tweet {
    
    var id : Int
    var name : String
    var screenName : String
    var text : String
    var retweetCount : Int
    var favoriteCount : Int
    
    var avatarURL : String
    var avatarImage : UIImage?
    
    var userDictionary : NSDictionary
    
    var hasImage = false
    
    // Initializer - Default Class Properties
    init (tweetInfo : NSDictionary) {
        let userInfo = tweetInfo["user"] as NSDictionary
        
        self.id = tweetInfo["id"] as Int
        self.name = userInfo["name"] as String
        self.screenName = userInfo["screen_name"] as String
        self.text = tweetInfo["text"] as String
        self.retweetCount = tweetInfo["retweet_count"] as Int
        self.favoriteCount = tweetInfo["favorite_count"] as Int
        self.avatarURL = userInfo["profile_image_url"] as String
        self.userDictionary = tweetInfo["user"] as NSDictionary
    }
    
    // Factory Method - very common to parse JSON in models rather than ViewControllers because reusability in different controllers
    class func parseJSONDataIntoTweets(rawJSONData : NSData) -> [Tweet]? {
        var error : NSError?
        
        // Using Objective-C NSArray and/or NSDictionary rather than Swift Array/Dictionary
        if let JSONArray = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSArray {
            var tweets = [Tweet]() // Shorthand to initialize array
            // println(JSONArray[0]) // Actual Twitter JSON
            
            // JSON file gives a dictionary for each tweet, loop through each JSON dictionary to create tweets
            for JSONDictionary in JSONArray {
                if let tweetDictionary = JSONDictionary as? NSDictionary {
                    var newTweet = Tweet(tweetInfo : tweetDictionary)
                    tweets.append(newTweet)
                }
            }
            
            return tweets
        }
        
        return nil
    }
}