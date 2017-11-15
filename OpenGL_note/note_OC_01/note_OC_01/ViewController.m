//
//  ViewController.m
//  note_OC_01
//
//  Created by qiansheng on 2017/11/13.
//  Copyright © 2017年 qiansheng. All rights reserved.
//

#import "ViewController.h"
#import "OpenView.h"
@interface ViewController ()
@property (nonatomic , strong) OpenView*   myView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.myView = (OpenView *)self.view;
    unsigned a = 0;
    NSLog(@"%d",-a);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
