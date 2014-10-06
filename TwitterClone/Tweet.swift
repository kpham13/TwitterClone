//
//  Tweet.swift
//  TwitterClone
//
//  Created by Kevin Pham on 10/6/14.
//  Copyright (c) 2014 Kevin Pham. All rights reserved.
//

import Foundation

// Model the class according to JSON
class Tweet {
    var text : String
    
    // Initializer(s) for default class properties
    init (tweetInfo : NSDictionary) {
        self.text = tweetInfo["text"] as String
    }
    
    // Factory method - very common to parse JSON in models rather than ViewControllers because you'll reuse in different ones
    class func parseJSONDataIntoTweets(rawJSONData : NSData) -> [Tweet]? {
        var error : NSError?
        
        // Using Objective-C NSArray and/or NSDictionary rather than Swift Array/Dictionary
        if let JSONArray = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSArray {
            var tweets = [Tweet]() // Shorthand to initialize array
            
            // JSON file gives a dictionary for each tweet, loop through each JSON dictionary to create tweets
            for JSONDictionary in JSONArray {
                if let tweetDictionary = JSONDictionary as? NSDictionary {
                    var newTweet = Tweet(tweetInfo: tweetDictionary)
                    tweets.append(newTweet)
                }
            }
            
            return tweets
        }
        
        return nil
    }
}