//
//  Image.swift
//  XCAppIcon
//
//  Created by Zakk Hoyt on 1/18/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import Cocoa


enum ImageIdiom: String {
    case iPhone = "iphone"
    case iPad = "ipad"
    case tvOS = "tvos"
    case iWatch = "iwatch"
}

enum ImageScale: String {
    case _1x = "1x"
    case _2x = "2x"
    case _3x = "3x"
}

class Image: NSObject {
    var size: CGFloat? = nil
    var idiom: ImageIdiom? = nil
    var filename: String? = nil
    var scale: ImageScale? = nil
    
    
    init(size: CGFloat, idiom: ImageIdiom, scale: ImageScale) {
        self.size = size
        self.idiom = idiom
        self.scale = scale
        
    }
    
    func jsonDict() -> NSDictionary? {
        guard let size = size,
            idiom = idiom,
            scale = scale else {
                print("Could not create dictionary")
                return nil
        }
        
        let f = floor(size)
        let sizeString = size == f ? "\(UInt(size))" : NSString(format: "%.1f", size)
        return [
            "size": "\(sizeString)x\(sizeString)",
            "idiom": idiom.rawValue,
            "filename": "\(size)x\(size).png",
            "scale": scale.rawValue
        ]
    }
}
