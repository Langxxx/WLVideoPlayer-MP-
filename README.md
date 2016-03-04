#WLVideoPlayer-MP-
用swift写的一个基于**MPMoviePlayerController**的视屏播放器，使用简单，可自定义视屏控制面板。


![image](http://7xnwdv.com1.z0.glb.clouddn.com/MPPlayer.gif)



# 使用

```
   playingPlayerView = WLVideoPlayerView(url: NSURL(string: urlStr)!)
        playingPlayerView?.customControlView = controlView //你需要的控制面板
        playingPlayerView?.placeholderView = UIImageView(image: UIImage(named: "placeholder")) // 视频加载时的等待图片
        playingPlayerView?.playInView(inView) // 播放
        // 更多功能请看PlayerControlView.swift提供的属性
```

关于自定义视屏控制面板，你只需要提供布局实现，所有的逻辑**WLVideoPlayer**已经帮助你实现。在**WLVideoPlayer**已经提供了两种参考实现，如果习惯使用XIB请参考**PlayerControlView.swift**，如果您习惯纯代码布局请参考**PlayerDemoControlView.swift**。当然你也可以直接使用或修改工程中提供的示例。

#项目简介

为了方便新同学学习多媒体视频播放的相关内容，已经把每一个步骤都打包成一个单独的工程

![image](http://7xnwdv.com1.z0.glb.clouddn.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-03-03%2021.45.56.png)

当然，你也完全可以从Github上clone整个项目

* 项目简介地址:[swift:基于MPMoviePlayerController的视频播放器][id1]

# 开发环境
* code7.2
* swift2.0


# 完善
日后会逐渐增加更多功能，并且开发相应**AVPlayer**版本如果您发现任何BUG,或者有更好的建议或者意见，欢迎您的指出。邮箱:wxl19950606@163.com.感谢您的支持


[id1]: http://www.jianshu.com/p/035be0175b55