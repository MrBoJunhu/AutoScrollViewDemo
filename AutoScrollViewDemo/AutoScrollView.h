//
//  AutoScrollView.h
//  AutoScrollViewDemo
//
//  Created by BillBo on 2017/7/18.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickImageBlock)(NSUInteger currentIndex);

@interface AutoScrollView : UIView


- (instancetype)initWithFrame:(CGRect)frame images:(NSMutableArray<UIImage *>*)imagesArray click:(clickImageBlock)click;

@end
