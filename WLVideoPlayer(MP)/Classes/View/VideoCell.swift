//
//  VideoCell.swift
//  网易新闻
//
//  Created by wl on 16/1/17.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit
import SDWebImage

let PlayerButtonDidClikNotification = "PlayerButtonDidClikNotification"
class VideoCell: UITableViewCell {
 
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    @IBOutlet weak var replyCountButton: UIButton!
    
    @IBOutlet weak var playerView: UIView!
    
    
    var newsModel: VideoNewsModel! {
        didSet {
            setupSubView()
        }
    }
    
    func setupSubView() {
        titleLabel.text = newsModel.title
        descriptionLabel.text = newsModel.description
        coverImageView.sd_setImageWithURL(NSURL(string: newsModel.cover), placeholderImage: UIImage(named: "placeholder"))
        timeLabel.text = String(format:"%02d:%02d", newsModel.length/60, newsModel.length%60)
        playCountLabel.text = String(newsModel.playCount)
        replyCountButton.setTitle(String(newsModel.replyCount), forState: .Normal)
    }
    /**
     当点击播放按钮的时候，通知控制器进行播放操作
     */
    @IBAction func playBtnClik(sender: UIButton) {
        let userInfo = [
            "inView" : self.playerView,
            "url" : self.newsModel.mp4_url,
            "cell" : self
        ]
        NSNotificationCenter.defaultCenter().postNotificationName(PlayerButtonDidClikNotification, object: self, userInfo: userInfo)
    }
}
