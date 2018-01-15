//
//  YYTransaction.swift
//  note_01
//
//  Created by qiansheng on 2017/12/11.
//  Copyright © 2017年 qiansheng. All rights reserved.
//


private let onceToken = UUID().uuidString
private var transactionSet : Set<YYTransaction>?

func YYTransactionSetup() {
    DispatchQueue.once(token: onceToken) {
        let runloop = CFRunLoopGetMain()
        var observe : CFRunLoopObserver?
        
        let YYRunLoopObserverCallBack : CFRunLoopObserverCallBack = {_,_,_ in
            if (transactionSet?.count ?? 0) == 0 {
                return
            }
            
            let currentSet = transactionSet
            transactionSet = Set()
            for item in currentSet! {
                _ = (item.target as? NSObject)?.perform(item.selector)
            }
        }
        
        observe = CFRunLoopObserverCreate(kCFAllocatorDefault, CFRunLoopActivity.beforeWaiting.rawValue | CFRunLoopActivity.exit.rawValue, true, 0xFFFFFF, YYRunLoopObserverCallBack, nil)
        
        CFRunLoopAddObserver(runloop, observe, .commonModes)
        observe = nil
    }
}

import UIKit

class YYTransaction: NSObject {
    var target : Any?
    var selector : Selector?
    
    static func transaction(target target: Any, selector: Selector) -> YYTransaction {
        let t = YYTransaction()
        t.target = target
        t.selector = selector
        return t
    }
    
    func commit() {
        if target == nil || selector == nil {return}
        
        
    }
    
    
    override var hash: Int {
        let v1 = selector?.hashValue ?? 0
        let v2 = (target as? NSObject)?.hashValue ?? 0
        return v1 ^ v2
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? YYTransaction {
            if other == self {
                return true
            }
            return other.selector == selector
        } else {
            return false
        }
    }
}
