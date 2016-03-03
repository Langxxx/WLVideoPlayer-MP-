//
//  PlayerControlViewAuxiliary.swift
//  WLVideoPlayer(MP)
//
//  Created by wl on 16/3/3.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit

protocol UpdateProgressProtocol {
    var timeText: String {get}
    func updateSliderViewWhenPlaying(currentPlaybackTime: NSTimeInterval, duration: NSTimeInterval, playableDuration: NSTimeInterval, updateConstant: ((finishPercent: CGFloat, playablePercent: CGFloat) -> Void)?)
    func updateSliderViewWhenSlide(inView: UIView, sender: UIPanGestureRecognizer, updateConstant: (point: CGPoint) -> Void)
}

extension UpdateProgressProtocol where Self : WLBasePlayerControlView {
    var timeText: String {
        return String(format: "%02d:%02d / %02d:%02d", Int(currentTime)/60, Int(currentTime)%60, Int(totalDuration)/60, Int(totalDuration)%60)
    }
    func updateSliderViewWhenPlaying(currentPlaybackTime: NSTimeInterval, duration: NSTimeInterval, playableDuration: NSTimeInterval, updateConstant: ((finishPercent: CGFloat, playablePercent: CGFloat) -> Void)?) {
        
        totalDuration = duration // 记录视频总长度
        currentTime = currentPlaybackTime
        
        let finishPercent = CGFloat(currentPlaybackTime / duration)
        let playablePercent = CGFloat(playableDuration / duration)
        updateConstant?(finishPercent: finishPercent, playablePercent: playablePercent)
    }
    
    func updateSliderViewWhenSlide(inView: UIView, sender: UIPanGestureRecognizer, updateConstant: (point: CGPoint) -> Void) {
        if sender.state == .Began { //开始拖动
            delegate?.beganSlideOnPlayerControlView?(self)
        }else if sender.state == .Ended { //拖动结束
            delegate?.playerControlView?(self, endedSlide: currentTime)
        }
        
        let point = sender.translationInView(inView)
        //相对位置清0
        sender.setTranslation(CGPointZero, inView: inView)
        updateConstant(point: point)
    }
    

}


