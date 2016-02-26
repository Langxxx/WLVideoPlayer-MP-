//
//  WLVideoPlayerView.swift
//  WLVideoPlayer(MP)
//
//  Created by wl on 16/2/24.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit
import MediaPlayer

//protocol WLPlayerControlViewDelegate: class {
//    func didClikOnPlayerControlView(playerControlView: PlayerControlView)
//    func playerControlView(playerControlView: PlayerControlView, pauseBtnDidClik pauseBtn: UIButton)
//    func playerControlView(playerControlView: PlayerControlView, enterFullScreenBtnDidClik enterFullScreenBtn: UIButton)
//    
//}

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
    /// 用户自定义控制界面
    var customControlView: WLBasePlayerControlView? {
        didSet {
            player.controlStyle = .None
        }
    }
    /// 自定义控制界面事件处理者
    lazy var playerControlHandler: WLPlayerHandler = WLPlayerHandler()
    
    private let defaultFrame = CGRectMake(0,0,0,0)
    /// 让一个view变得透明但能够响应事件的透明度
    private let HiddenAlpha: CGFloat = 0.02
    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("playerWillEnterFullscreen"), name: MPMoviePlayerWillEnterFullscreenNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("playerWillExitFullscreen"), name: MPMoviePlayerWillExitFullscreenNotification, object: nil)
    }

     // MARK: - 监听方法/回调方法
    
    /**
    播放的视频"可以播放"的时候调用,设置播放的控制面板
    */
    func playerReadyForDisplayDidChange() {
        
        placeholderView?.removeFromSuperview()
        guard let customControlView = self.customControlView else {
            return
        }
        // 只有用户使用了自定义视频控制面板才会运行到这
        player.controlStyle = .None
        customControlView.frame = self.bounds
        customControlView.setVirtualHidden(false)
        self.addSubview(customControlView)
        
        // 让playerControlHandler 处理视频控制事件
        customControlView.delegate = playerControlHandler
        playerControlHandler.player = player
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            customControlView.setVirtualHidden(true)
        }
    }
    /**
     视频进入全屏模式的时候调用，
     目的是为了处理自定义视频控制器的显示问题
     */
    func playerWillEnterFullscreen() {
        
        guard let customControlView = self.customControlView else {
            return
        }
        
        let windwon = UIApplication.sharedApplication().keyWindow!
        
        windwon.addSubview(customControlView)
        customControlView.frame = windwon.bounds
        windwon.bringSubviewToFront(customControlView)
    }
    /**
     视频退出全屏模式的时候调用，
     目的是为了处理自定义视频控制器的显示问题
     */
    func playerWillExitFullscreen() {
        guard let customControlView = self.customControlView else {
            return
        }
        customControlView.frame = self.bounds
        self.addSubview(customControlView)
    }
    
}
