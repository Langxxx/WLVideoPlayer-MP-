//
//  MediaController.swift
//  WLVideoPlayer(MP)
//
//  Created by wl on 16/2/24.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit

class MediaController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var videoNewsArray: [VideoNewsModel]? {
        didSet {
            tableView.reloadData()

        }
    }
    
    /// 正在播放视频的URL
    var playingNewsUrl: String = ""
    /// 正在播放视频的播放器
    var playingPlayerView: WLVideoPlayerView?
    /// 播放视频的那个cell，解决重用问题
    var playingCell: VideoCell?
    /// 播放视频的那个cell的索引，解决重用问题
    var playingCellIndexPath: NSIndexPath?
    lazy var controlView = {
        return NSBundle.mainBundle().loadNibNamed("PlayerControlView", owner: nil, options: nil).last as! PlayerControlView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 5
        tableView.sectionFooterHeight = 5
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        automaticallyAdjustsScrollViewInsets = false
        
        DataTool.loadMediaNewsData("http://c.m.163.com/nc/video/home/0-10.html") { (news) -> Void in
            guard let videoNewsArray = news else {
                return
            }
            self.videoNewsArray = videoNewsArray
        }
        
        // 监听播放视频的通知事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playNewsVideo:", name: PlayerButtonDidClikNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     视频播放通知事件的回调函数，在点击某一个cell的播放按钮的时候调用，
     进行视频新闻播放
     - parameter notification: 一些播放视频所需要的信息
     */
    func playNewsVideo(notification: NSNotification) {
        
        let dict = notification.userInfo
        guard let urlStr = dict?["url"] as? String,
            let inView = dict?["inView"] as? UIView,
            let playingCell = dict?["cell"] as? VideoCell
            where urlStr != playingNewsUrl else {
                print("重复播放")
                return
        }
        
        playingPlayerView?.removeFromSuperview()
        playingPlayerView = nil
        // 处理cell重用
        self.playingCell = playingCell
        playingCellIndexPath = tableView.indexPathForCell(playingCell)
        
        playingPlayerView = WLVideoPlayerView(url: NSURL(string: urlStr)!)
        playingPlayerView?.customControlView = controlView
        playingPlayerView?.placeholderView = UIImageView(image: UIImage(named: "placeholder"))
        playingPlayerView?.playInView(inView)
    }
    
}

extension MediaController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return videoNewsArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let newsModel = videoNewsArray![indexPath.section]
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoCell", forIndexPath: indexPath) as! VideoCell
        cell.newsModel = newsModel

        // 是否 是重用正在播放的那个cell
        if let playingCell = playingCell where playingCell == cell {
            // 是重用的正在播放的那个cell
            // 判断这个重用的cell是原本就应该播放视频的，还是其他行重用的
            if let playingCellIndexPath = playingCellIndexPath where playingCellIndexPath == indexPath {
                // 走到这里表示这个cell就是原本需要播放视频的那一行
                playingPlayerView?.hidden = false
            }else {
                // 走到这里表示这个cell是重用的原本需要播放视频的那一行
                playingPlayerView?.hidden = true
            }
        }
        
        return cell
    }
    
}
