//
//  ZKShop.swift
//  PhotoBrowser
//
//  Created by 闫振奎 on 15/3/15.
//  Copyright © 2015年 only. All rights reserved.
//

import UIKit

class ZKShop: NSObject {
    var q_pic_url : String = ""
    var z_pic_url : String = ""
    
    init(dict : [String : NSObject]) {
        super.init()
        
        // 利用KVC字典转模型
        setValuesForKeysWithDictionary(dict)
        
    }
    
    // 重写父类以下方法,避免报错
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
