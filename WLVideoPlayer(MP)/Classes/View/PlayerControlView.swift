//
//  PlayerControlView.swift
//  网易新闻
//
//  Created by wl on 16/2/23.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit

//protocol WLPlayerControlViewDelegate: class {
//    func didClikOnPlayerControlView(playerControlView: PlayerControlView)
//    func playerControlView(playerControlView: PlayerControlView, pauseBtnDidClik pauseBtn: UIButton)
//    func playerControlView(playerControlView: PlayerControlView, enterFullScreenBtnDidClik enterFullScreenBtn: UIButton)
//    
//}

class PlayerControlView: WLBasePlayerControlView {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var currentSliderConstraint: NSLayoutConstraint!
    @IBOutlet weak var playableSliderConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        let pan = UIPanGestureRecognizer(target: self, action: Selector("onSliderPan:"))
        sliderView.addGestureRecognizer(pan)

        let tap = UITapGestureRecognizer(target: self, action: Selector("tap"))
        self.addGestureRecognizer(tap)
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
    @IBAction func pauseBtnClik(sender: UIButton) {
        self.delegate?.playerControlView?(self, pauseBtnDidClik: sender)
    }
    /**
     当进入/退出全屏按钮被点击的时候调用
     通知代理处理相关事件
     */
    @IBAction func enterFullScreenBtnClik(sender: UIButton) {
        self.delegate?.playerControlView?(self, enterFullScreenBtnDidClik: sender)
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
        currentSliderConstraint.constant = finishPercent * sliderView.bounds.size.width
        playableSliderConstraint.constant = playablePercent * sliderView.bounds.size.width
        timeLabel.text = String(format: "%02d:%02d / %02d:%02d", Int(currentPlaybackTime)/60, Int(currentPlaybackTime)%60, Int(duration)/60, Int(duration)%60)
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
        
        currentSliderConstraint.constant += point.x
        if currentSliderConstraint.constant < 0 {
            currentSliderConstraint.constant = 0
        }else if currentSliderConstraint.constant > sliderView.bounds.width {
            currentSliderConstraint.constant = sliderView.bounds.width
        }
        
        let finishPercent = NSTimeInterval(currentSliderConstraint.constant / sliderView.bounds.width)
        currentTime = finishPercent * totalDuration
        timeLabel.text = String(format: "%02d:%02d / %02d:%02d", Int(currentTime)/60, Int(currentTime)%60, Int(totalDuration)/60, Int(totalDuration)%60)
        
        
    }
    
}
