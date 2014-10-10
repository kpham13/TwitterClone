//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Kevin Pham on 10/7/14.
//  Copyright (c) 2014 Kevin Pham. All rights reserved.
//

import UIKIT

// Custom Cell Class
class TweetCell: UITableViewCell {
    
    let replyIcon = UIImage(named: "reply.png")
    let retweetIcon = UIImage(named: "retweet.png")
    let favoriteIcon = UIImage(named: "favorite.png")
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var userNameText: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}