//
//  WLBasePlayerControlView.swift
//  WLVideoPlayer(MP)
//
//  Created by wl on 16/2/25.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit

@objc protocol WLPlayerControlViewDelegate: class {
    
    optional func didClikOnPlayerControlView(playerControlView: WLBasePlayerControlView)
    optional func playerControlView(playerControlView: WLBasePlayerControlView, pauseBtnDidClik pauseBtn: UIButton)
    optional func playerControlView(playerControlView: WLBasePlayerControlView, enterFullScreenBtnDidClik enterFullScreenBtn: UIButton)
}

class WLBasePlayerControlView: UIView {

    weak var delegate: WLPlayerControlViewDelegate?
    
    /// 让这个view变得透明但能够响应事件的透明度
    let HiddenAlpha: CGFloat = 0.02
    
    /**
     让这个view变得透明并且能够响应点击事件
     */
    func setVirtualHidden(isTrue: Bool) {
        if isTrue {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.alpha = self.HiddenAlpha
            })
        }else {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.alpha = 1
            })
        }
    }
    /**
     让这个view变得透明并且能够响应点击事件,自动判断
     */
    func setVirtualHidden() {
        if (self.alpha - HiddenAlpha) < 0.001 { // 判断2个浮点数是否相等
            self.setVirtualHidden(false)
        }else {
            self.setVirtualHidden(true)
        }
    }
}

