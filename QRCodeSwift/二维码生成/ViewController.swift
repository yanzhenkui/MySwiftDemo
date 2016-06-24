//
//  ViewController.swift
//  二维码生成
//
//  Created by 闫振奎 on 16/3/3.
//  Copyright © 2016年 only. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {

    @IBOutlet weak var inputText: UITextView!

    @IBOutlet weak var resultImage: UIImageView!



    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        


     resultImage.image = ZKQRCodeTool.createQRCodeImage(inputText.text, size: 200, iconImage: UIImage(named: "minion.png"))

    }



}

