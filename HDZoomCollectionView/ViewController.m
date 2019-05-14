//
//  ViewController.m
//  HDZoomCollectionView
//
//  Created by 邓立兵 on 2019/4/11.
//  Copyright © 2019 harry. All rights reserved.
//

#import "ViewController.h"

#import "HDZoomCollectionView.h"
#import "HDDemoCollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource>

@property (nonatomic, strong) HDZoomCollectionViewFlowLayout *zoomLayout;
@property (nonatomic, strong) HDZoomCollectionView *zoomView;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger rowNumber; //页面一共多少行
@property (nonatomic, assign) NSInteger listNumber; //页面一共多少行

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _rowNumber = 10;
    _listNumber = 1600 / _rowNumber;
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.zoomView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.zoomView.scrollView setContentOffset:CGPointMake(self.zoomView.scrollView.contentSize.width - self.zoomView.scrollView.bounds.size.width, 0) animated:NO];
    });
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.zoomView.frame = self.view.bounds;
}

#pragma mark - 延迟实例化
- (HDZoomCollectionView *)zoomView {
    if (!_zoomView) {
        CGFloat itemWidth = self.view.frame.size.height / _rowNumber;
        _zoomLayout = [[HDZoomCollectionViewFlowLayout alloc] initItemSize:CGSizeMake(itemWidth, itemWidth)
                                                                   columns:_listNumber
                                                               itemSpacing:0.0
                                                                     scale:1.0];
        
        _zoomView = [[HDZoomCollectionView alloc] initWithFrame:self.view.bounds layout:_zoomLayout];
        _zoomView.collectionView.dataSource = self;
        [_zoomView.collectionView registerClass:HDDemoCollectionViewCell.class forCellWithReuseIdentifier:@"HDDemoCollectionViewCell"];
        
        _zoomView.collectionView.backgroundColor = [UIColor blackColor];
        
        _zoomView.scrollView.minimumZoomScale = 0.5;
        _zoomView.scrollView.zoomScale = 1.0;
        _zoomView.scrollView.maximumZoomScale = 4.0;
    }
    return _zoomView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [@[] mutableCopy];
        for (int x=0; x<_rowNumber; x++) {
            for (int i=x; i<_listNumber * _rowNumber; i+=_rowNumber) {
                [_dataArr insertObject:@1 atIndex:0];
            }
        }
    }
    return _dataArr;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HDDemoCollectionViewCell *cell = (HDDemoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HDDemoCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

@end
