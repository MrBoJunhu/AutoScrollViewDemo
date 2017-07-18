//
//  ViewController.m
//  AutoScrollViewDemo
//
//  Created by BillBo on 2017/7/18.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import "ViewController.h"
#import "AutoScrollView.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    CGFloat screen_Width = [UIScreen mainScreen].bounds.size.width;
    
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i = 0; i < 3; i ++) {
        
        UIImage *tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
        
        if (images != nil) {
            
             [images addObject:tempImage];
            
        }
        
    }
    
    AutoScrollView *v = [[AutoScrollView alloc] initWithFrame:CGRectMake(10, 100, screen_Width - 20, 100) images:images click:^(NSUInteger currentIndex) {
        
        NSLog(@"%ld", currentIndex);
    
    }];
    
    [self.view addSubview:v];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
