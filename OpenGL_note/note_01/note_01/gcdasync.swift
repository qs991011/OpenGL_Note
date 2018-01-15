//
//  gcdasync.swift
//  note_01
//
//  Created by qiansheng on 2017/12/11.
//  Copyright © 2017年 qiansheng. All rights reserved.
//

import UIKit

class gcdasync: NSObject {
    
    
    func simpleQueue() {
        let queue = DispatchQueue(label: "gcd1")
        queue.sync {
            for i in 0..<10 {
                print("同步队列执行")
            }
        }
        
        for j in 0..<10 {
            print("同步主队列执行")
        }
    }
    
    func asfunction()  {
        let queue = DispatchQueue(label: "che")
        queue.async {
            for j in 0..<10 {
                print("我是耗时操作")
            }
        }
        
        let qos : DispatchQoS.QoSClass = .default
        //.userInitiated > .default > .utility > .background
        
        DispatchQueue.global(qos: qos).async {
            for j in 0..<10 {
                print("我也是耗时操作")
            }
        }
        
        
    }

    
    
    
    

}
