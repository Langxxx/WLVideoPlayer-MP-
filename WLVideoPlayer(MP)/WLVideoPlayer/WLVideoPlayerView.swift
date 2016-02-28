//
//  WLVideoPlayerView.swift
//  WLVideoPlayer(MP)
//
//  Created by wl on 16/2/24.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit
import MediaPlayer

let WLPlayerCustomControlViewStateDidChangeNotification = "WLPlayerCustomControlViewStateDidChangeNotiffication"

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
    
    // ps: 因为swift中暂时不支持(或者作者本人没找到)像oc中这样的写法:UIView<someProtocol> *obj
    // 也就是说不支持定义一个变量，让他是UIView的子类，并且这个View必须遵守某个协议,妥协之下，便设置了一个类似于接口的一个父类
    /// 用户自定义控制界面
    var customControlView: WLBasePlayerControlView? {
        didSet {
            player.controlStyle = .None
        }
    }
    /// 用户自定义视频控制面板自动隐藏的时间
    var customControlViewAutoHiddenInterval: NSTimeInterval = 3 {
        didSet {
            playerControlHandler.customControlViewAutoHiddenInterval = customControlViewAutoHiddenInterval
        }
    }
    /// 自定义控制界面事件处理者
    lazy var playerControlHandler: WLPlayerHandler = WLPlayerHandler()
    
    private let defaultFrame = CGRectMake(0,0,0,0)
    /// 1秒调用一次，用来更新用户自定义视频控制面板上进度条以及时间的显示
    private var progressTimer: NSTimer?
    
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
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    /**
     为了防止定制器造成循环引用
     */
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if newSuperview == nil {
            removeProgressTimer()
        }
    }
    
    func play() {
        player.play()
        if let placeholderView = self.placeholderView {
            placeholderView.frame = self.bounds
            self.addSubview(placeholderView)
            self.bringSubviewToFront(placeholderView)
        }
        setupCustomControlView()
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("playerWillEnterFullscreen"), name: MPMoviePlayerWillEnterFullscreenNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("playerWillExitFullscreen"), name: MPMoviePlayerWillExitFullscreenNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("moviePlaybackStateDidChange"), name: MPMoviePlayerPlaybackStateDidChangeNotification, object: nil)
    }
    /**
     当播放视频进入播放状态且用户自定义了视频控制面板的时候调动，
     添加一个定时器，为了更新用户自定义视频控制面板
     */
    private func addProgressTimer() {
        
        guard let customControlView = self.customControlView else {
            return
        }
        
        removeProgressTimer()
        let timer = NSTimer(timeInterval: 1.0, target: self, selector: Selector("updateProgress"), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        self.progressTimer = timer
        // 立即更新控制面板显示内容
        playerControlHandler.updateProgress(customControlView)
    }
    /**
     当任何事件导致视频进入停止、暂停状态的时候调用
     移除更新自定义视频控制面板的那个定时器
     */
    private func removeProgressTimer() {
        self.progressTimer?.invalidate()
        self.progressTimer = nil
    }

    /**
     在用户点击播放按钮后调用(第一次播放某视频，一个视频只会调用一次)
     设置用户自定义视频控制器一些属性，
     起初是隐藏的，当视频真正播放的时候才展示
     */
    private func setupCustomControlView() {
        guard let customControlView = self.customControlView else {
            return
        }
        // 只有用户使用了自定义视频控制面板才会运行到这
        player.controlStyle = .None
        customControlView.frame = self.bounds
        self.addSubview(customControlView)
        customControlView.hidden = true
        
        // 让playerControlHandler 处理视频控制事件
        customControlView.delegate = playerControlHandler
        playerControlHandler.player = player
        playerControlHandler.customControlView = customControlView
        
    }
    /**
     视频进入播放状态的时候进行调用(可能重复调用)
     */
    func readyToPlayer() {

        placeholderView?.removeFromSuperview()
        guard let customControlView = self.customControlView else {
            return
        }
        // 只有用户使用了自定义视频控制面板才会运行到这,开启自动更新面板的定时器
        customControlView.hidden = false
        customControlView.setVirtualHidden(false)
        addProgressTimer()

        NSNotificationCenter.defaultCenter().postNotificationName(WLPlayerCustomControlViewStateDidChangeNotification, object: nil)
    }

     // MARK: - 监听方法/回调方法
    
    /**
    定时器回调方法，在视频播放的时候，每一秒调用一次，
    用来更新进度条以及播放的时间
    */
    func updateProgress() {
        playerControlHandler.updateProgress(customControlView!)
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
    
    /**
     当视频状态发生改变的时候调用
     */
    func moviePlaybackStateDidChange() {
        switch player.playbackState {
        case .Stopped:
            removeProgressTimer()
            break
        case .Playing:
            readyToPlayer()
            break
        case .Paused:
            removeProgressTimer()
            break
        case .Interrupted:
            print("Interrupted")
            break
        case .SeekingForward, .SeekingBackward:
            removeProgressTimer()
            break
        }
    }
    
}
