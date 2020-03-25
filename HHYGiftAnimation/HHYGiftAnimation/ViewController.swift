//
//  ViewController.swift
//  HHYGiftAnimation
//
//  Created by 华惠友 on 2020/3/25.
//  Copyright © 2020 com.development. All rights reserved.
//

import UIKit
import ImageIO

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.加载gif图片,并转为Data类型
        guard let path = Bundle.main.path(forResource: "demo.gif", ofType: nil) else { return }
        guard let data = NSData(contentsOfFile: path) else { return }
        
        // 2.从data中读取数据,将data转为CGImageSource对象
        guard let imageSource = CGImageSourceCreateWithData(data, nil) else { return }
        let imageCount = CGImageSourceGetCount(imageSource)
        
        // 3.遍历图片
        var images = [UIImage]()
        var totalDuration: TimeInterval = 0
        for i in 0..<imageCount {
            // 3.1.取出图片
            guard let cgImage =  CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            let image = UIImage(cgImage: cgImage)
            if i == 0 {
                imageView.image = image
            }
            images.append(image)
            
            // 3.2.取出图片持续的时间
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) else { continue }
            guard let gifDic = (properties as NSDictionary)[kCGImagePropertyGIFDictionary] as? NSDictionary else { continue }
            guard let frameDuration = gifDic[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
            totalDuration += frameDuration.doubleValue
        }
        
        // 4.设置imageView的属性
        imageView.animationImages = images
        imageView.animationDuration = totalDuration
        imageView.animationRepeatCount = 1
        
        // 5.开始播放
        imageView.startAnimating()
        
        
    }


}

