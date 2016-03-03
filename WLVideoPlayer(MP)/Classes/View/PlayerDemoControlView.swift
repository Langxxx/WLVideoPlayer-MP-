//
//  PlayerDemoControlView.swift
//  WLVideoPlayer(MP)
//
//  Created by wl on 16/3/2.
//  Copyright © 2016年 wl. All rights reserved.
//  代码布局的控制面板，提供参考实现

import UIKit
import SnapKit

class PlayerDemoControlView: WLBasePlayerControlView {

    private let defaultFrame = CGRectMake(0,0,0,0)
    
    weak var pauseBtn: UIButton!
    weak var enterFullscreenBtn: UIButton!
    weak var timeLabel: UILabel!
    weak var topImageView: UIImageView!
    weak var bottomView: UIView!
    weak var playableImageView: UIImageView!
    weak var leftSliderImageView: UIImageView!
    weak var sliderView: UIView!
    
    init() {
        super.init(frame: defaultFrame)
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("tap"))
        self.addGestureRecognizer(tap)
        
        let topImageView = UIImageView()
        topImageView.image = UIImage(named: "player_topshadow")
        self.addSubview(topImageView)
        topImageView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(self.snp_width)
            make.height.equalTo(40)
            make.top.equalTo(self.snp_top)
            make.left.equalTo(self.snp_left)
        }
        self.topImageView = topImageView
        
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        self.addSubview(bottomView)
        bottomView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(self.snp_width)
            make.height.equalTo(topImageView.snp_height)
            make.bottom.equalTo(self.snp_bottom)
            make.left.equalTo(self.snp_left)
        }
        self.bottomView = bottomView
        
        let pauseBtn = UIButton()
        pauseBtn.setImage(UIImage(named: "player_pause"), forState: .Normal)
        pauseBtn.setImage(UIImage(named: "player_play"), forState: .Selected)
        bottomView.addSubview(pauseBtn)
        pauseBtn.addTarget(self, action: Selector("pauseBtnClik"), forControlEvents: .TouchUpInside)
        pauseBtn.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bottomView)
            make.bottom.equalTo(bottomView)
            make.left.equalTo(bottomView)
            make.width.equalTo(50)
        }
        self.pauseBtn = pauseBtn
        
        let enterFullscreenBtn = UIButton()
        enterFullscreenBtn.setImage(UIImage(named: "player_fullscreen"), forState: .Normal)
        enterFullscreenBtn.setImage(UIImage(named: "player_embeddedscreen"), forState: .Selected)
        enterFullscreenBtn.addTarget(self, action: Selector("enterFullScreenBtnClik"), forControlEvents: .TouchUpInside)
        bottomView.addSubview(enterFullscreenBtn)
        enterFullscreenBtn.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bottomView)
            make.bottom.equalTo(bottomView)
            make.right.equalTo(bottomView)
            make.width.equalTo(50)
        }
        self.enterFullscreenBtn = enterFullscreenBtn
        
        let timeLabel = UILabel()
        timeLabel.text = "00:00 / 00:00"
        timeLabel.font = UIFont.systemFontOfSize(13)
        timeLabel.textColor = UIColor.whiteColor()
        timeLabel.textAlignment = .Right
        bottomView.addSubview(timeLabel)
        timeLabel.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(bottomView)
            make.right.equalTo(enterFullscreenBtn.snp_left)
            make.height.equalTo(bottomView).multipliedBy(0.5)
        }
        self.timeLabel = timeLabel
        
        let sliderView = UIView()
        sliderView.backgroundColor = UIColor.clearColor()
        bottomView.addSubview(sliderView)
        sliderView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bottomView)
            make.bottom.equalTo(bottomView)
            make.right.equalTo(enterFullscreenBtn.snp_left)
            make.left.equalTo(pauseBtn.snp_right)
        }
        self.sliderView = sliderView
        
        let pan = UIPanGestureRecognizer(target: self, action: Selector("onSliderPan:"))
        sliderView.addGestureRecognizer(pan)
        
        let leftSliderImageView = UIImageView()
        leftSliderImageView.image = UIImage(named: "player_leftslider")
        sliderView.addSubview(leftSliderImageView)
        leftSliderImageView.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(sliderView)
            make.left.equalTo(sliderView)
            make.height.equalTo(2)
            make.width.equalTo(20)
        }
        self.leftSliderImageView = leftSliderImageView
        
        let thumbImageView = UIImageView()
        thumbImageView.image = UIImage(named: "player_thumb")
        sliderView.addSubview(thumbImageView)
        thumbImageView.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(sliderView)
            make.left.equalTo(leftSliderImageView.snp_right)
            make.height.equalTo(10)
            make.width.equalTo(10)
        }
        
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "player_rightslider")
        sliderView.addSubview(rightImageView)
        rightImageView.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(sliderView)
            make.left.equalTo(thumbImageView.snp_right)
            make.right.equalTo(sliderView)
            make.height.equalTo(2)
        }
        
        let playableImageView = UIImageView()
        playableImageView.image = UIImage(named: "player_playableslider")
        playableImageView.alpha = 0.4
        sliderView.addSubview(playableImageView)
        playableImageView.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(sliderView)
            make.left.equalTo(sliderView)
            make.height.equalTo(2)
            make.width.equalTo(40)
        }
        self.playableImageView = playableImageView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     自定义控制面板应该实现这个方法，
     实现此方法，将会自动更新面板上显示内容:时间、进度条等
     - parameter currentPlaybackTime: 当前时间
     - parameter duration:            视频总时长
     - parameter playableDuration:    已经缓冲的时长
     */
    override func updateProgress(currentPlaybackTime: NSTimeInterval, duration: NSTimeInterval, playableDuration: NSTimeInterval) {
        totalDuration = duration // 记录视频总长度
        let finishPercent = CGFloat(currentPlaybackTime / duration)
        let playablePercent = CGFloat(playableDuration / duration)
        leftSliderImageView.snp_updateConstraints(closure: { (make) -> Void in
            make.width.equalTo(finishPercent * sliderView.bounds.size.width)
        })
        playableImageView.snp_updateConstraints { (make) -> Void in
            make.width.equalTo(playablePercent * sliderView.bounds.size.width)
        }
        timeLabel.text = String(format: "%02d:%02d / %02d:%02d", Int(currentPlaybackTime)/60, Int(currentPlaybackTime)%60, Int(duration)/60, Int(duration)%60)
    }
    /**
     每次播放器的播放模式发生变化的生活调用(进入\退出全屏\旋转等)
     用来更新视图上的约束
     */
    override func relayoutSubView() {
        
        guard let superview = self.superview else {
            return
        }

        let orientation = UIDevice.currentDevice().orientation
        let isLandscape = orientation == .LandscapeLeft || orientation == .LandscapeRight

        self.snp_remakeConstraints { (make) -> Void in
            make.top.equalTo(self.superview!)
            make.left.equalTo(self.superview!)
            make.width.equalTo(isLandscape ? superview.snp_height : superview.snp_width)
            make.height.equalTo(isLandscape ? superview.snp_width : superview.snp_height)
        }
        self.layoutSubviews()
    }

    override func didMoveToSuperview() {
        self.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self.superview!)
            make.bottom.equalTo(self.superview!)
            make.top.equalTo(self.superview!)
            make.left.equalTo(self.superview!)
        }
    }

    
    override func getEnterFullscreenBtn() -> UIButton? {
        return enterFullscreenBtn
    }
    // MARK: - 监听方法
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    func tap() {
        self.delegate?.didClikOnPlayerControlView?(self)
    }
    
    /**
     当暂停/播放按钮被点击的时候调用
     通知代理处理相关事件
     */
    func pauseBtnClik() {
        self.delegate?.playerControlView?(self, pauseBtnDidClik: pauseBtn!)
    }
    /**
     当进入/退出全屏按钮被点击的时候调用
     通知代理处理相关事件
     */
    func enterFullScreenBtnClik() {
        self.delegate?.playerControlView?(self, enterFullScreenBtnDidClik: enterFullscreenBtn!)
    }
    
    /**
     滑动手势的回调方法，在滑动进度条的时候调用
     用来设置新的播放进度(时间)
     */
    func onSliderPan(sender: UIPanGestureRecognizer) {
        
        if sender.state == .Began { //开始拖动
            delegate?.beganSlideOnPlayerControlView?(self)
        }else if sender.state == .Ended { //拖动结束
            delegate?.playerControlView?(self, endedSlide: currentTime)
        }
        
        let point = sender.translationInView(sliderView)
        //相对位置清0
        sender.setTranslation(CGPointZero, inView: sliderView)
        leftSliderImageView.snp_updateConstraints { (make) -> Void in
            make.width.equalTo(leftSliderImageView.bounds.width+point.x)
            
        }
        
        let leftPercent = NSTimeInterval(leftSliderImageView.bounds.width / sliderView.bounds.width)
        currentTime = leftPercent * totalDuration
        timeLabel.text = String(format: "%02d:%02d / %02d:%02d", Int(currentTime)/60, Int(currentTime)%60, Int(totalDuration)/60, Int(totalDuration)%60)
    }

}
