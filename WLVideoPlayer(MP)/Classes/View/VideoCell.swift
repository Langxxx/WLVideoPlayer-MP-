//
//  VideoCell.swift
//  网易新闻
//
//  Created by wl on 16/1/17.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit
import SDWebImage



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
            self.setupSubView()
        }
    }
    
    func setupSubView() {
        
        self.titleLabel.text = self.newsModel.title
        self.descriptionLabel.text = self.newsModel.description
        self.coverImageView.sd_setImageWithURL(NSURL(string: self.newsModel.cover), placeholderImage: UIImage(named: "placeholder"))
        self.timeLabel.text = String(format:"%02d:%02d", self.newsModel.length/60, self.newsModel.length%60)
        self.playCountLabel.text = String(self.newsModel.playCount)
        self.replyCountButton.setTitle(String(self.newsModel.replyCount), forState: .Normal)
    }
    /**
     当点击播放按钮的时候，通知控制器进行播放操作
     */
    @IBAction func playBtnClik(sender: UIButton) {

    }
}
