//
//  YYSentinel.swift
//  note_01
//
//  Created by qiansheng on 2017/12/11.
//  Copyright © 2017年 qiansheng. All rights reserved.
//

import UIKit

class YYSentinel {
    
    private var _value : Int32 = 0
    
    public var value: Int32 {
        return _value
    }
    
    @discardableResult
    
    public func increase() -> Int32 {
        
        return OSAtomicIncrement32(&_value)
    }
}
