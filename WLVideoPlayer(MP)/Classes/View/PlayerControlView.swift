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

     // MARK: - 监听方法
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
    
}
