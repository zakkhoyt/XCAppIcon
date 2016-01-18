//
//  Info.swift
//  XCAppIcon
//
//  Created by Zakk Hoyt on 1/18/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import Cocoa

class Info: NSObject {

    func jsonDict() -> NSDictionary? {
        return ["version": 1, "author": "xcode"]
    }

}
