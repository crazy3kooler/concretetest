//
//  avatarCacheService.swift
//  recrutamento_concrete
//
//  Created by Arilson Carmo on 2/2/16.
//  Copyright © 2016 arilson. All rights reserved.
//

import UIKit

private let downloadQueue = dispatch_queue_create("com.arilsoncarmo.recrutamento-concrete", nil)


class ImageCacheService {
    var avatarCache: NSCache
    
    init() {
        avatarCache = NSCache()
    }
    func getAvatarCache(url: NSURL) -> UIImage? {
        if let img = avatarCache.objectForKey(url) as? UIImage {
            return img
        }
        return nil
    }
    
    /*
    *  Async method to load image..
    *  parameters: an url from image and callback to completion
    */
    func asyncLoadImageContent(imageURL: NSURL, completion: (image: UIImage) -> Void) {
        dispatch_async(downloadQueue) { () -> Void in
            if let data = NSData(contentsOfURL: imageURL) {
                let image = UIImage(data: data)
                dispatch_async(dispatch_get_main_queue()) {
                    self.avatarCache.setObject(image!, forKey: imageURL)
                    completion(image: image!)
                }
            }
        }
    }
    
}
