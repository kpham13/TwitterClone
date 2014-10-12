//
//  TwitterService.swift
//  TwitterClone
//
//  Created by Kevin Pham on 10/8/14.
//  Copyright (c) 2014 Kevin Pham. All rights reserved.
//

import UIKIt
import Accounts
import Social

class TwitterService {

    /* // Singleton - Best Practice in Swift
    class var sharedInstance: NetworkController {
    struct Static {
        static var instance: NetworkController?
        static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = NetworkController()
        }
        return Static.instance!
    }
    */
    
    var twitterAccount : ACAccount?
    var imageDownloadQueue = NSOperationQueue()
    
    // var tweetCount = "20"
    
    // Required init
    init () {
        self.imageDownloadQueue.maxConcurrentOperationCount = 6
    }
    
    func fetchHomeTimeline(completionHandler : (errorDescription : String?, tweets : [Tweet]?) -> (Void)) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        // Asynchronous Operation (not on the main thread)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error : NSError!) -> Void in
            if granted {
                let accounts = accountStore.accountsWithAccountType(accountType) // accountType has been captured
                self.twitterAccount = accounts.first as ACAccount?
                
                // Setup Twitter Request
                let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json") // Twitter REST API Resource URL
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                
                // Perform Twitter Request
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    switch httpResponse.statusCode {
                    case 200...299:
                        let tweets = Tweet.parseJSONDataIntoTweets(data)
                        println("GOOD")
                        
                        // Display User's Timeline (via main thread)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            // Function Paramater Arguments
                            completionHandler(errorDescription: nil, tweets: tweets)
                        })
                        
                        // println("Good. ", httpResponse.statusCode, httpResponse.description)
                    case 400...499:
                        completionHandler(errorDescription: "The Client is at fault.", tweets: nil)
                        // println("Uh oh... ", httpResponse.statusCode, httpResponse.description)
                    case 500...599:
                        completionHandler(errorDescription: "The Server is at fault.", tweets: nil)
                        // println("Uh oh... ", httpResponse.statusCode, httpResponse.description)
                    default:
                        completionHandler(errorDescription: "Something bad happened.", tweets: nil)
                        // println("Uh oh... ", httpResponse.statusCode, httpResponse.description)
                    }
                })
            }
        }
    }
    
    func refreshHomeTimeline(tweetID : Int, completionHandler : (errorDescription : String?, tweets : [Tweet]?) -> (Void)) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        // Asynchronous Operation (not on the main thread)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error : NSError!) -> Void in
            if granted {
                let accounts = accountStore.accountsWithAccountType(accountType) // accountType has been captured
                self.twitterAccount = accounts.first as ACAccount?
        
                // Setup Twitter Request
                let twitterAPI = "https://api.twitter.com/1.1/statuses/home_timeline.json"
                //println(tweetID)
                //println(twitterAPI)
                var twitterURL = twitterAPI + "?since_id=" + String(tweetID)
                println(twitterURL)
                let url = NSURL(string: twitterURL) // Twitter REST API Resource URL
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                
                // Perform Twitter Request
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    switch httpResponse.statusCode {
                    case 200...299:
                        let tweets = Tweet.parseJSONDataIntoTweets(data)
                        
                        // Display User's Timeline (via main thread)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            // Function Paramater Arguments
                            completionHandler(errorDescription: nil, tweets: tweets)
                        })
                        
                        // println("Good. ", httpResponse.statusCode, httpResponse.description)
                    case 400...499:
                        completionHandler(errorDescription: "The Client is at fault.", tweets: nil)
                        // println("Uh oh... ", httpResponse.statusCode, httpResponse.description)
                    case 500...599:
                        completionHandler(errorDescription: "The Server is at fault.", tweets: nil)
                        // println("Uh oh... ", httpResponse.statusCode, httpResponse.description)
                    default:
                        completionHandler(errorDescription: "Something bad happened.", tweets: nil)
                        // println("Uh oh... ", httpResponse.statusCode, httpResponse.description)
                    }
                })
            }
        }
    }
    
    func scrollHomeTimeline(tweetID : Int, completionHandler : (errorDescription : String?, tweets : [Tweet]?) -> (Void)) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        // Asynchronous Operation (not on the main thread)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error : NSError!) -> Void in
            if granted {
                let accounts = accountStore.accountsWithAccountType(accountType) // accountType has been captured
                self.twitterAccount = accounts.first as ACAccount?
                
                // Setup Twitter Request
                let twitterAPI = "https://api.twitter.com/1.1/statuses/home_timeline.json"
                //println(tweetID)
                //println(twitterAPI)
                var twitterURL = twitterAPI + "?max_id=" + String(tweetID)
                println(twitterURL)
                let url = NSURL(string: twitterURL) // Twitter REST API Resource URL
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                
                // Perform Twitter Request
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    switch httpResponse.statusCode {
                    case 200...299:
                        let tweets = Tweet.parseJSONDataIntoTweets(data)
                        
                        // Display User's Timeline (via main thread)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            // Function Paramater Arguments
                            completionHandler(errorDescription: nil, tweets: tweets)
                        })
                        
                        // println("Good. ", httpResponse.statusCode, httpResponse.description)
                    case 400...499:
                        completionHandler(errorDescription: "The Client is at fault.", tweets: nil)
                        // println("Uh oh... ", httpResponse.statusCode, httpResponse.description)
                    case 500...599:
                        completionHandler(errorDescription: "The Server is at fault.", tweets: nil)
                        // println("Uh oh... ", httpResponse.statusCode, httpResponse.description)
                    default:
                        completionHandler(errorDescription: "Something bad happened.", tweets: nil)
                        // println("Uh oh... ", httpResponse.statusCode, httpResponse.description)
                    }
                })
            }
        }
    }

    func fetchUserTimeline(userScreenName : String, completionHandler : (errorDescription : String?, tweets : [Tweet]?) -> (Void)) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        // Asynchronous Operation (not on the main thread)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error : NSError!) -> Void in
            if granted {
                let accounts = accountStore.accountsWithAccountType(accountType) // accountType has been captured
                self.twitterAccount = accounts.first as ACAccount?
                
                // Setup Twitter Request
                let twitterUserAPI = "https://api.twitter.com/1.1/statuses/user_timeline.json"
                var twitterUserURL = twitterUserAPI + "?screen_name=" + userScreenName //+ "&count=" + self.tweetCount
                let url = NSURL(string: twitterUserURL) // Twitter REST API Resource URL
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                
                // Perform Twitter Request
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    switch httpResponse.statusCode {
                    case 200...299:
                        let tweets = Tweet.parseJSONDataIntoTweets(data)
                        
                        // Display User's Timeline (via main thread)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            // Function Paramater Arguments
                            completionHandler(errorDescription: nil, tweets: tweets)
                        })
                        
                        //println("Good. ", httpResponse.statusCode, httpResponse.description)
                    case 400...499:
                        completionHandler(errorDescription: "The Client is at fault.", tweets: nil)
                        //println("Uh oh... ", httpResponse.statusCode, httpResponse.description)
                    case 500...599:
                        completionHandler(errorDescription: "The Server is at fault.", tweets: nil)
                        //println("Uh oh... ", httpResponse.statusCode, httpResponse.description)
                    default:
                        completionHandler(errorDescription: "Something bad happened.", tweets: nil)
                        //println("Uh oh... ", httpResponse.statusCode, httpResponse.description)
                    }
                })
            }
        }
    }
    
    func refreshUserTimeline(userScreenName : String, tweetID : Int, completionHandler : (errorDescription : String?, tweets : [Tweet]?) -> (Void)) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        // Asynchronous Operation (not on the main thread)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error : NSError!) -> Void in
            if granted {
                let accounts = accountStore.accountsWithAccountType(accountType) // accountType has been captured
                self.twitterAccount = accounts.first as ACAccount?
                
                // Setup Twitter Request
                let twitterAPI = "https://api.twitter.com/1.1/statuses/user_timeline.json"
                //println(tweetID)
                //println(twitterAPI)
                var twitterURL = twitterAPI + "?screen_name=" + userScreenName + "&since_id=" + String(tweetID)
                //println(twitterURL)
                let url = NSURL(string: twitterURL) // Twitter REST API Resource URL
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                
                // Perform Twitter Request
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    switch httpResponse.statusCode {
                    case 200...299:
                        let tweets = Tweet.parseJSONDataIntoTweets(data)
                        
                        // Display User's Timeline (via main thread)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            // Function Paramater Arguments
                            completionHandler(errorDescription: nil, tweets: tweets)
                        })
                        
                        // println("Good. ", httpResponse.statusCode, httpResponse.description)
                    case 400...499:
                        completionHandler(errorDescription: "The Client is at fault.", tweets: nil)
                        // println("Uh oh... ", httpResponse.statusCode, httpResponse.description)
                    case 500...599:
                        completionHandler(errorDescription: "The Server is at fault.", tweets: nil)
                        // println("Uh oh... ", httpResponse.statusCode, httpResponse.description)
                    default:
                        completionHandler(errorDescription: "Something bad happened.", tweets: nil)
                        // println("Uh oh... ", httpResponse.statusCode, httpResponse.description)
                    }
                })
            }
        }
    }
    
    func scrollUserTimeline(userScreenName : String, tweetID : Int, completionHandler : (errorDescription : String?, tweets : [Tweet]?) -> (Void)) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        // Asynchronous Operation (not on the main thread)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error : NSError!) -> Void in
            if granted {
                let accounts = accountStore.accountsWithAccountType(accountType) // accountType has been captured
                self.twitterAccount = accounts.first as ACAccount?
                
                // Setup Twitter Request
                let twitterAPI = "https://api.twitter.com/1.1/statuses/user_timeline.json"
                //println(tweetID)
                //println(twitterAPI)
                var twitterURL = twitterAPI + "?screen_name=" + userScreenName + "&max_id=" + String(tweetID)
                //println(twitterURL)
                let url = NSURL(string: twitterURL) // Twitter REST API Resource URL
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                
                // Perform Twitter Request
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    switch httpResponse.statusCode {
                    case 200...299:
                        let tweets = Tweet.parseJSONDataIntoTweets(data)
                        
                        // Display User's Timeline (via main thread)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            // Function Paramater Arguments
                            completionHandler(errorDescription: nil, tweets: tweets)
                        })
                        
                        // println("Good. ", httpResponse.statusCode, httpResponse.description)
                    case 400...499:
                        completionHandler(errorDescription: "The Client is at fault.", tweets: nil)
                        // println("Uh oh... ", httpResponse.statusCode, httpResponse.description)
                    case 500...599:
                        completionHandler(errorDescription: "The Server is at fault.", tweets: nil)
                        // println("Uh oh... ", httpResponse.statusCode, httpResponse.description)
                    default:
                        completionHandler(errorDescription: "Something bad happened.", tweets: nil)
                        // println("Uh oh... ", httpResponse.statusCode, httpResponse.description)
                    }
                })
            }
        }
    }
    
    // NSOperations - Asynchronous download of user images
    func downloadUserImage(tweet : Tweet, completionHandler : (image : UIImage) -> (Void)) {
        var downloadOperation = NSBlockOperation { () -> Void in
            let avatarURL = NSURL(string: tweet.avatarURL)
            let avatarData = NSData(contentsOfURL: avatarURL) // Network Call
            let avatarImage = UIImage(data: avatarData) // Most intensive, converting data to image
            tweet.avatarImage = avatarImage
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(image: avatarImage) // completionHandler is the image, which will be sent to TableView (i.e cell.avatarImageView.image = avatarImage)
                // self.imageActivity.stopAnimating()
            })
        }
        
        // downloadOperation.qualityOfService = NSQualityOfService.Background
        self.imageDownloadQueue.addOperation(downloadOperation)
    }
}
