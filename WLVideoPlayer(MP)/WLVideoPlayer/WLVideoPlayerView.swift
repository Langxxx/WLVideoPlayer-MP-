//
//  WLVideoPlayerView.swift
//  WLVideoPlayer(MP)
//
//  Created by wl on 16/2/24.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit
import MediaPlayer

class WLVideoPlayerView: UIView {
    
    var player: MPMoviePlayerController
    /// 播放地址
    var contentURL: NSURL? {
        didSet {
            player.contentURL = contentURL
        }
    }
    /// 视频等待的占位图片
    var placeholderView: UIView?
    
    private let defaultFrame = CGRectMake(0,0,0,0)
    
    init(url : NSURL?) {
        contentURL = url
        player = MPMoviePlayerController(contentURL: contentURL)
        
        super.init(frame: defaultFrame)
        
        self.addSubview(player.view)
        player.view.translatesAutoresizingMaskIntoConstraints = false
        let h = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view" : player.view])
        let v = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view" : player.view])
        self.addConstraints(h)
        self.addConstraints(v)
        
        setupNotification()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("WLVideoPlayerView===deinit")
    }
    
    func play() {
        player.play()
        if let placeholderView = self.placeholderView {
            placeholderView.frame = self.bounds
            self.addSubview(placeholderView)
            self.bringSubviewToFront(placeholderView)
        }
    }
    
    func playInView(inView: UIView) {
        
        self.removeFromSuperview()
        self.frame = inView.bounds
        inView.addSubview(self)
        play()
    }
    
    func playInview(inView: UIView, withURL url: NSURL) {
        contentURL = url
        playInView(inView)
    }
    
    /**
     添加视频通知事件
     */
    private func setupNotification() {
        //播放的视频"可以播放"的时候调用
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("playerReadyForDisplayDidChange"), name: MPMoviePlayerReadyForDisplayDidChangeNotification, object: nil)
    }
    
     // MARK: - 监听方法/回调方法
    
    /**
    播放的视频"可以播放"的时候调用,设置播放的控制面板
    */
    func playerReadyForDisplayDidChange() {
        placeholderView?.removeFromSuperview()
    }
    
}
