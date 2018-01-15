//
//  ViewController.swift
//  note_01
//
//  Created by qiansheng on 2017/11/9.
//  Copyright © 2017年 qiansheng. All rights reserved.
//

import UIKit
import renttaxi
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let openView = OpneGLView(frame: self.view.bounds)
        let vc = RenttaxiController()
        
        
        
        
        
        
        //QSLog.DDLog(message: self)
        //NumberFormatterTool().changeFormatter()
        gcdasync().asfunction()
        //self.view.addSubview(openView)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

