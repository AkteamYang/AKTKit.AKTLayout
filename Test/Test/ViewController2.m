//
//  ViewController2.m
//  Test
//
//  Created by YaHaoo on 16/4/20.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "ViewController2.h"
#import "ViewController.h"

@interface ViewController2 ()
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ViewController *v = [ViewController new];
        [self presentViewController:v animated:YES completion:nil];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
