//
//  ZKNetworkTools.swift
//  PhotoBrowser
//
//  Created by 闫振奎 on 15/3/15.
//  Copyright © 2015年 only. All rights reserved.
//

import UIKit
import AFNetworking

class ZKNetworkTools: AFHTTPSessionManager {
    // 将类设计为单例
    static let shareIntance : ZKNetworkTools = {
        let tool = ZKNetworkTools()
        tool.responseSerializer.acceptableContentTypes?.insert("text/html")
        return tool
    }()
    
    func loadHomeData(offset : Int , finishedCallBack : (resultArray : [[String : NSObject]]?, error : NSError?) -> ()) {
        // 1.获取请求的URLString
        let urlString = "http://mobapi.meilishuo.com/2.0/twitter/popular.json?offset=\(offset)&limit=30&access_token=b92e0c6fd3ca919d3e7547d446d9a8c2"
        
        // 2.发送网络请求
        GET(urlString, parameters: nil, progress: nil, success: { (_, result) -> Void in
            // 1.将Anyobject?转成字典类型
            guard let resultDict = result as? [String : NSObject] else {
                print("没有拿到正确数据")
                return
            }
            // 2.从字典中将数组取出
            let dictArray = resultDict["data"] as? [[String : NSObject]]
            
            // 3.将数据回调出去
            finishedCallBack(resultArray: dictArray, error: nil)
            
            }) { (_, error) -> Void in
                print(error)
        }
    }
}
