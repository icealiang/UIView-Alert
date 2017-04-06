//
//  ViewController.m
//  UIAlertDemo
//
//  Created by 许谢良 on 2017/4/6.
//  Copyright © 2017年 许谢良. All rights reserved.
//

#import "ViewController.h"
#import "UIView+XLAlert.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addAlert];
}

- (void)addAlert {
    
    [self.view xl_showAlertWithTitle:@"demo" message:@"UIView+XLAlert" confirmTitle:@"确定" cancleTitle:@"取消" confirmHandle:^(UIAlertAction *confirmAction) {
        [self.view showToastWithText:@"点击了确定"];
    } cancleHandle:^(UIAlertAction *confirmAction) {
        [self.view showToastWithText:@"点击了取消"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
