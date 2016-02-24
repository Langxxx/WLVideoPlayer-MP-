//
//  MediaController.swift
//  WLVideoPlayer(MP)
//
//  Created by wl on 16/2/24.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit

class MediaController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var videoNewsArray: [VideoNewsModel]? {
        didSet {
            self.tableView.reloadData()

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.sectionHeaderHeight = 5
        self.tableView.sectionFooterHeight = 5
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.automaticallyAdjustsScrollViewInsets = false
        
        DataTool.loadMediaNewsData("http://c.m.163.com/nc/video/home/0-10.html") { (news) -> Void in
            guard let videoNewsArray = news else {
                return
            }
            self.videoNewsArray = videoNewsArray
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension MediaController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.videoNewsArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let newsModel = self.videoNewsArray![indexPath.section]
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoCell", forIndexPath: indexPath) as! VideoCell
        cell.newsModel = newsModel

        return cell
    }
    
}
