//
//  WLPlayerHandler.swift
//  WLVideoPlayer(MP)
//
//  Created by wl on 16/2/25.
//  Copyright © 2016年 wl. All rights reserved.
//  处理用户自定义控制面板逻辑的对象

import UIKit
import MediaPlayer

class WLPlayerHandler: NSObject, WLPlayerControlViewDelegate{
    
    weak var player: MPMoviePlayerController!

    /**
     WLBasePlayerControlView的代理方法，
     当点击视频控制View的空白处调用
     主要是用来显示\隐藏视频控制View
     */
    func didClikOnPlayerControlView(playerControlView: WLBasePlayerControlView) {
        playerControlView.setVirtualHidden()
    }
    /**
     WLBasePlayerControlView的代理方法，
     当点击暂停/播放的时候调用
     用来暂停/播放视频
     - parameter playerControlView: 用户自定义的那个控制面板
     - parameter pauseBtn:          暂停/播放按钮
     */
    func playerControlView(playerControlView: WLBasePlayerControlView, pauseBtnDidClik pauseBtn: UIButton) {
        assert(player != nil, "player is nil")
        if pauseBtn.selected { //暂停==>播放
            player.play()
        }else {
            player.pause()
        }
        
        pauseBtn.selected = !pauseBtn.selected
    }
    
    // TODO: 这样全屏实现不太好，后期将会自定义全屏
    /**
     WLBasePlayerControlView的代理方法，
     当点击进入/退出全屏的时候调用
     用来进入/退出全屏
     - parameter playerControlView: 用户自定义的那个控制面板
     - parameter pauseBtn:          全屏/退出全屏按钮
     */
    func playerControlView(playerControlView: WLBasePlayerControlView, enterFullScreenBtnDidClik enterFullScreenBtn: UIButton) {
        
        assert(player != nil, "player is nil")
        
        playerControlView.removeFromSuperview()
        if enterFullScreenBtn.selected { //全屏==>退出全屏
            player.setFullscreen(false, animated: true)
        }else {
            player.setFullscreen(true, animated: true)
        }
        
        enterFullScreenBtn.selected = !enterFullScreenBtn.selected
    }
}


