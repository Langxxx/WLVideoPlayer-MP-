//
//  DataTool.swift
//  网易新闻
//
//  Created by wl on 15/11/11.
//  Copyright © 2015年 wl. All rights reserved.
//  获得网络数据的工具

import Foundation
import Alamofire
import SwiftyJSON

struct DataTool {
    /**
     加载视听模块数据
     
     - parameter completionHandler: 返回数据的回调闭包
     */
    static func loadMediaNewsData(urlStr:String, completionHandler: ([VideoNewsModel]?) -> Void) {

        
        Alamofire.request(.GET, urlStr).responseJSON { (response) -> Void in
            guard response.result.error == nil else {
                print("load news error!")
                completionHandler(nil)
                return
            }
            let data = JSON(response.result.value!)
            
            let videoNewsJSON = data["videoList"]
            var videoNewsArray: [VideoNewsModel] = []
            for (_, dict) in videoNewsJSON {
                
                videoNewsArray.append(VideoNewsModel(json: dict))
            }
            
            completionHandler(videoNewsArray)
        }
    }

}
