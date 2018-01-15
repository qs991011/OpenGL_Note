//
//  YYAsyncLayer.swift
//  note_01
//
//  Created by qiansheng on 2017/12/11.
//  Copyright © 2017年 qiansheng. All rights reserved.
//


let YYAsyncLayerGetReleaseQueue : DispatchQueue = {
    return DispatchQueue.global(qos: .utility)
}()

private let onceToken = UUID().uuidString
private let MAX_QUEUE_COUNT = 16

private var queueCount = 0
private var queues = [DispatchQueue](repeating: DispatchQueue(label:""),count:MAX_QUEUE_COUNT)

private var counter : Int32 = 0

var YYAsyncLayerGetDisplayQueue : DispatchQueue {
    DispatchQueue.once(token:onceToken) {
        queueCount = ProcessInfo().activeProcessorCount
        queueCount = queueCount < 1 ? 1 : queueCount > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : queueCount
        for i in 0 ..< queueCount {
            queues[i] = DispatchQueue(label: "com.ibireme.MTKit.render")
        }
    }
    var cur = OSAtomicIncrement32(&counter)
    if cur < 0 {
        cur = -cur
    }
    
    return queues[Int(cur) % queueCount]
}


import UIKit

class YYAsyncLayer: CALayer {
    
    public var displayAsynchronously = true
    
    private var _sentinel : YYSentinel!
    
    private let _onceToken = UUID().uuidString
    
    
    
    override class func defaultValue(forKey key: String) -> Any? {
        if key == "displaysAsynchronously" {
            return true
        } else {
            return super.defaultValue(forKey: key)
        }
        
    }
    
    lazy var scale :CGFloat = 0
    
    override init() {
        super.init()
        DispatchQueue.once(token: _onceToken) {
            scale = UIScreen.main.scale
        }
        
        contentsScale = scale
        _sentinel = YYSentinel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        _sentinel.increase()
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
    }
    
    override func display() {
        super.contents = super.contents
    }
    
    private func _displayAsync(_ async : Bool) {
        guard let mydelegate = delegate as? YYAsyncLayerDelegate else { return }
        
        let task = mydelegate.newAsyncDisplayTask
        
        if task.display == nil {
            task.willDisplay?(self)
            contents = nil
            task.didDisplay?(self,true)
            return
        }
        
        if async {
            
            task.willDisplay?(self)
            
            let sentinel = _sentinel
            
            let value = sentinel!.value
            let isCanceled : (() -> Bool) = {
                return value != sentinel?.value
            }
            let size = bounds.size
            let opaque = isOpaque
            let scale = contentsScale
            let backgroundColor = (opaque && self.backgroundColor != nil) ? self.backgroundColor : nil
            //太小不绘制
            if size.width < 1 || size.height < 1 {
                var image = contents
                contents = nil
                if image != nil {
                    YYAsyncLayerGetReleaseQueue.async {
                        image = nil
                    }
                }
                task.didDisplay?(self,true)
                return
            }
            // 将绘制操作放入自定义队列
            YYAsyncLayerGetDisplayQueue.async {
                if isCanceled() {
                    return
                }
                //第一个参数表示所要创建的图片的
                // 第二个参数用来指定所生成的图片背景是否为不透明  如上我们使用true而不是false 则我们得到的图片背景将会是黑色的 这显然不是我想要的
                // 第三个参数是指定生成图片的缩放因子 这个缩放因子与UIImage的scale属性所指定的含义是一致的 传入0则表示让图片的缩放因子根据屏幕的分辨率而变化 所以我们得到的图片不管是在单分辨率还是视网膜屏上看起来都会很好看
                //与 UIGraphicsEndImageContext() 成对出现
                // iOS中新增UIGraphicsImageRender(bounds:_)
                 
                
                UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
                guard let context = UIGraphicsGetCurrentContext() else {return}
                
                if opaque {
                    context.saveGState()
                    if backgroundColor == nil || backgroundColor!.alpha < 1 {
                        context.setFillColor(UIColor.white.cgColor)//设置填充颜色
                        context.addRect(CGRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale))
                        context.fillPath()//填充路径
                    }
                    
                    if let backgroundColor = backgroundColor {
                        context.setFillColor(backgroundColor)
                        context.addRect(CGRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale))
                        context.fillPath()
                    }
                    context.restoreGState()
                }
                
                task.display?(context, size, isCanceled)
                if isCanceled() {
                    UIGraphicsEndImageContext()
                    DispatchQueue.main.async {
                        task.didDisplay?(self, false)
                    }
                    return
                }
                
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                if isCanceled() {
                    DispatchQueue.main.async {
                        task.didDisplay?(self, false)
                    }
                    return
                }
                DispatchQueue.main.async {
                    if isCanceled() {
                        task.didDisplay?(self, false)
                    } else {
                        self.contents = image?.cgImage
                        task.didDisplay?(self, true)
                    }
                }
                
            }
        } else{
            _sentinel.increase()
            task.willDisplay?(self)
            UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, contentsScale)
            guard let context = UIGraphicsGetCurrentContext() else { return }
            if isOpaque {
                var size = bounds.size
                size.width *= contentsScale
                size.height *= contentsScale
                context.saveGState()
                if backgroundColor == nil || backgroundColor!.alpha < 1 {
                    context.setFillColor(UIColor.white.cgColor)
                    context.addRect(CGRect(origin: .zero, size: size))
                    context.fillPath()
                }
                if let backgroundColor = backgroundColor {
                    context.setFillColor(backgroundColor)
                    context.addRect(CGRect(origin: .zero, size: size))
                    context.fillPath()
                }
                context.restoreGState()
            }
            task.display?(context, bounds.size, {return false})
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndPDFContext()
            contents = image?.cgImage
            task.didDisplay?(self, true)
        }
        
    }
    
    private func cancelAsyncDisplay() {
        _sentinel?.increase()
    }
    

}

protocol YYAsyncLayerDelegate {
    var newAsyncDisplayTask : YYAsyncLayerDisplayTak { get }
    
}

class YYAsyncLayerDisplayTak {
    
    public var willDisplay: ((CALayer) -> Void)?
    
    public var display: ((_ context : CGContext, _ size : CGSize, _ isCanceled:(() ->Bool)?) -> Void)?
    
    public var didDisplay:((_ layer : CALayer, _ finished: Bool) -> Void)?
}

extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    public class func once(token:String,block:() -> Void) {
        
        objc_sync_enter(self); defer { objc_sync_exit(self)}
        
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}
