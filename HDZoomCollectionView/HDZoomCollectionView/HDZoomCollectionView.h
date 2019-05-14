//
//  HDZoomCollectionView.h
//  HDZoomCollectionView
//
//  Created by 邓立兵 on 2019/4/11.
//  Copyright © 2019 harry. All rights reserved.
//  对 https://github.com/helmutschneider/ZoomCollectionView 的翻译

#import <UIKit/UIKit.h>

#import "HDZoomCollectionViewFlowLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDZoomCollectionView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *dummyZoomView;
@property (nonatomic, strong) HDZoomCollectionViewFlowLayout *layout;

- (instancetype)initWithFrame:(CGRect)frame layout:(HDZoomCollectionViewFlowLayout *)layout;

@end

NS_ASSUME_NONNULL_END
