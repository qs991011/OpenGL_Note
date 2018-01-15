//
//  QSLog.swift
//  note_01
//
//  Created by qiansheng on 2017/12/8.
//  Copyright © 2017年 qiansheng. All rights reserved.
//

import UIKit

class QSLog: NSObject {
   static  func DDLog<T>(message:T,file:String = #file,funcName:String = #function,lineNum:Int = #line)  {
        #if DEBUG
        
            let fileName = (file as NSString).lastPathComponent
            print("[\(fileName)][\(funcName)]\(lineNum):\(message)")
        #endif
        
    }

}
