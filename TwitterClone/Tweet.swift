//
//  Tweet.swift
//  TwitterClone
//
//  Created by Kevin Pham on 10/6/14.
//  Copyright (c) 2014 Kevin Pham. All rights reserved.
//

import Foundation

// Model Class According to JSON
class Tweet {
    
    var text : String
    var userDictionary : NSDictionary
    
    // Initializer - Default Class Properties
    init (tweetInfo : NSDictionary) {
        self.text = tweetInfo["text"] as String
        self.userDictionary = tweetInfo["user"] as NSDictionary
    }
    
    // Factory Method - very common to parse JSON in models rather than ViewControllers because reusability in different controllers
    class func parseJSONDataIntoTweets(rawJSONData : NSData) -> [Tweet]? {
        var error : NSError?
        
        // Using Objective-C NSArray and/or NSDictionary rather than Swift Array/Dictionary
        if let JSONArray = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSArray {
            var tweets = [Tweet]() // Shorthand to initialize array
            
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