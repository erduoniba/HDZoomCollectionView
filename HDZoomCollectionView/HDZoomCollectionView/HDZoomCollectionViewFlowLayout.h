//
//  HDZoomCollectionViewFlowLayout.h
//  HDZoomCollectionView
//
//  Created by 邓立兵 on 2019/4/11.
//  Copyright © 2019 harry. All rights reserved.
//  对 https://github.com/helmutschneider/ZoomCollectionView 的翻译

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDZoomCollectionViewFlowLayout : UICollectionViewLayout

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat columns;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) CGFloat scale;

- (instancetype)initItemSize:(CGSize)itemSize columns:(CGFloat)columns itemSpacing:(CGFloat)itemSpacing scale:(CGFloat)scale;

- (CGSize)contentSizeForScale:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
