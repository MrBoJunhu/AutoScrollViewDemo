//
//  AutoScrollView.m
//  AutoScrollViewDemo
//
//  Created by BillBo on 2017/7/18.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import "AutoScrollView.h"

#define IMAGE_COUNT 3
#define weakify(x)autoreleasepool{} __weak typeof(x)weak##x=x;
#define ENABLE_DEBUG
#ifdef ENABLE_DEBUG
#define DebugLog(format, args...) \
NSLog(@"%s, line %d: " format "\n", \
__func__, __LINE__, ## args);
#else
#define DebugLog(format, args...) do {} while(0)
#endif

@interface AutoScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scvView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic,assign) NSUInteger currentPageIndex;

@property (nonatomic, assign) NSUInteger totalPages;

@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) UIImageView *middleImageView;

@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, copy) clickImageBlock clickBlock;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AutoScrollView

- (instancetype)initWithFrame:(CGRect)frame images:(NSMutableArray<UIImage *>*)imagesArray click:(clickImageBlock)click{
    
    if (self = [super initWithFrame:frame]) {
        
        self.clickBlock = click;
        
        _currentPageIndex = 0;
        
        [self.imagesArray addObjectsFromArray:imagesArray];
        
        _totalPages = self.imagesArray.count;
        
        self.scvView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        self.scvView.contentSize = CGSizeMake(frame.size.width * IMAGE_COUNT, frame.size.height);
        
        [self addSubview:self.scvView];
        
        [self.scvView setContentOffset:CGPointMake(frame.size.width, 0) animated:NO];
        
        [self addImages];
  
        [self setDefaultImage];
        
        [self addSubview:self.pageControl];
        
        self.pageControl.center = CGPointMake(self.center.x, frame.size.height - self.pageControl.frame.size.height/2);
        
    
    }
    
    return self;
}

- (NSMutableArray *)imagesArray{
    
    if (!_imagesArray) {
        
        self.imagesArray = [NSMutableArray array];
        
    }
    
    return _imagesArray;
}

- (UIScrollView *)scvView{
    
    if (!_scvView) {
       
        self.scvView = [[UIScrollView alloc] init];
        
        self.scvView.delegate = self;
        
        self.scvView.pagingEnabled = YES;
        
        self.scvView.showsHorizontalScrollIndicator = NO;
        
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] init];
        
        [tapG addTarget:self action:@selector(tapAction:)];
        
        [self.scvView addGestureRecognizer:tapG];
    
        [self.timer setFireDate:[NSDate distantPast]];
  
    }
    
    return _scvView;
}

- (UIPageControl *)pageControl{
   
    if (!_pageControl) {
    
        self.pageControl = [[UIPageControl alloc] init];
        
        CGSize size = [self.pageControl sizeForNumberOfPages:_totalPages];
        
        self.pageControl.frame = CGRectMake(0, 0, size.width, size.height);
        
        self.pageControl.currentPage = _currentPageIndex;
        
        self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
        
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        
        self.pageControl.numberOfPages = _totalPages;
    
        self.pageControl.userInteractionEnabled = NO;
        
    }
    
    return _pageControl;
    
}

- (NSTimer *)timer{
   
    if (!_timer) {
        
        @weakify(self);
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
           
//            [weakself autoScroll];
        
        }];
    
    }
    
    return _timer;
    
}

- (void)addImages {
    
    CGFloat image_Width = self.scvView.frame.size.width;
    
    CGFloat image_Height = self.scvView.frame.size.height;
    
    UIViewContentMode contentModel =  UIViewContentModeScaleAspectFill;
    
    _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image_Width, image_Height)];
    
    _leftImageView.contentMode = contentModel;
    
    [self.scvView addSubview:_leftImageView];
    
    _middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(image_Width, 0, image_Width, image_Height)];
    
    _middleImageView.contentMode = contentModel;
    
    [self.scvView addSubview:_middleImageView];
    
    _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(image_Width * 2, 0, image_Width, image_Height)];
    
    _rightImageView.contentMode = contentModel;
    
    [self.scvView addSubview:_rightImageView];
    
}


- (void)setDefaultImage {
    
    _leftImageView.image = self.imagesArray[IMAGE_COUNT - 1];
    
    _middleImageView.image = self.imagesArray.firstObject;
    
    _rightImageView.image = self.imagesArray[1];
}

#pragma mark - scrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self reloadImage];
    
    [self.scvView setContentOffset:CGPointMake(scrollView.frame.size.width, 0) animated:NO];
    
    _pageControl.currentPage = _currentPageIndex;
    
}

- (void)reloadImage {
    
    NSUInteger leftImageIndex, rightImageIndex;
   
    CGPoint offset = self.scvView.contentOffset;
    
    if (offset.x > self.scvView.frame.size.width) {
        //向右滑动
        _currentPageIndex = (_currentPageIndex + 1) % _totalPages;
        
    }else if (offset.x < self.scvView.frame.size.width){
        
        _currentPageIndex = (_currentPageIndex + _totalPages - 1) % _totalPages;
        
    }
    
    _middleImageView.image = self.imagesArray[_currentPageIndex];
    
    leftImageIndex = (_currentPageIndex + _totalPages - 1) % _totalPages;
    
    rightImageIndex = (_currentPageIndex + 1) % _totalPages;
    
    _leftImageView.image = self.imagesArray[leftImageIndex];
    
    _rightImageView.image = self.imagesArray[rightImageIndex];
    
    
}

//- (void)autoScroll {
//    
//    if (self.currentPageIndex == self.totalPages-1) {
//        
//        self.currentPageIndex = 0;
//    
//    }else if(self.currentPageIndex < self.totalPages - 1){
//    
//        self.currentPageIndex ++;
//    
//    }
//    
//    self.pageControl.currentPage = _currentPageIndex;
//    
//    [self.scvView setContentOffset:CGPointMake(self.scvView.frame.size.width * self.currentPageIndex, 0) animated:NO];
//    
//    [self reloadImage];
//    
//}


- (void)tapAction:(UITapGestureRecognizer *)sender {
    
    if (self.clickBlock) {
        
        self.clickBlock(_currentPageIndex);
        
    }
    
}


@end
