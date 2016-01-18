//
//  AppIcon.swift
//  XCAppIcon
//
//  Created by Zakk Hoyt on 1/18/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import Cocoa

class AppIcon: NSObject {
    var images: [Image] = []
    var info = Info()
    
    private func jsonDict() -> NSDictionary? {
        let dict = NSMutableDictionary()
        let infoDict = info.jsonDict()
        dict.setValue(infoDict, forKey: "info")

        
        let imageDicts = NSMutableArray()
        for image in images {
            if let imageDict = image.jsonDict() {
                imageDicts.addObject(imageDict)
            }
        }
        dict.setValue(imageDicts, forKey: "images")
        return dict
    }
    
    func json() -> NSString? {
        if let jsonDict = jsonDict() {
            do {
                let data = try NSJSONSerialization.dataWithJSONObject(jsonDict, options: .PrettyPrinted)
                let string = NSString(data: data, encoding: NSUTF8StringEncoding)
                return string
            } catch _ {
                print("Error converting json dictionary to data")
            }
        } else {
            print("No valid jsonDict")
        }
        
        return nil
    }
}
