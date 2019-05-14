//
//  HDZoomCollectionView.m
//  HDZoomCollectionView
//
//  Created by 邓立兵 on 2019/4/11.
//  Copyright © 2019 harry. All rights reserved.
//

#import "HDZoomCollectionView.h"

#import <CoreGraphics/CoreGraphics.h>

@interface HDZoomCollectionView () <UIScrollViewDelegate, UICollectionViewDelegate>

@end

@implementation UICollectionView (hd)

// credit to http://stackoverflow.com/questions/17704527/uicollectionview-not-removing-old-cells-after-scroll
- (NSArray <UICollectionViewCell *> *)getLingeringCells {
    CGRect visibleRect = CGRectMake(self.contentOffset.x, self.contentOffset.y, self.bounds.size.width, self.bounds.size.height);
    NSArray *visibleCells = self.visibleCells;
    NSMutableArray *cells = [@[] mutableCopy];
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([view isKindOfClass:UICollectionViewCell.class] ) {
            if (CGRectIntersectsRect(visibleRect, view.frame)) {
                if (![visibleCells containsObject:view]) {
                    [cells addObject:view];
                }
            }
        }
    }];
    return cells;
}

- (void)hideLingeringCells {
    NSArray *LingeringCells = [self getLingeringCells];
    [LingeringCells enumerateObjectsUsingBlock:^(UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
}

@end


@implementation HDZoomCollectionView

- (instancetype)initWithFrame:(CGRect)frame layout:(HDZoomCollectionViewFlowLayout *)layout {
    self = [super initWithFrame:frame];
    if (self) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.collectionView.backgroundColor = [UIColor blackColor];
        self.dummyZoomView = [[UIView alloc] initWithFrame:CGRectZero];
        
        self.layout = layout;
        __weak typeof(self) weak_self = self;
        [self.collectionView.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weak_self.collectionView removeGestureRecognizer:obj];
        }];
        
        self.scrollView.delegate = self;
        self.collectionView.delegate = self;
        
        [self addSubview:self.collectionView];
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.dummyZoomView];
        
        self.scrollView.bouncesZoom = NO;
        [self bringSubviewToFront:self.scrollView];
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTapGesture setNumberOfTapsRequired:2];
        [ self.scrollView addGestureRecognizer:doubleTapGesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
    self.scrollView.frame = self.bounds;
    CGSize size = [self.layout contentSizeForScale:self.scrollView.zoomScale];
    self.scrollView.contentSize = size;
    self.dummyZoomView.frame = CGRectMake(0, 0, size.width, size.height);
    
    [self setImageViewCenter];
}

// 这个方法是针对scrollView在缩小放大时，或者是旋转时候无法居中的问题，scrollView放大，只要在设置完zoomScale之后设置偏移量为(0,0)即可实现放大居中
- (void)setImageViewCenter {
    CGFloat offsetX = MAX((self.scrollView.bounds.size.width - self.scrollView.contentInset.left - self.scrollView.contentInset.right - self.scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((self.scrollView.bounds.size.height - self.scrollView.contentInset.top - self.scrollView.contentInset.bottom - self.scrollView.contentSize.height) * 0.5, 0.0);
    self.collectionView.center = CGPointMake(self.scrollView.center.x + offsetX, self.scrollView.center.y + offsetY);
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender {
    [self.scrollView setZoomScale:1 animated:NO];
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.dummyZoomView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.collectionView.contentOffset = scrollView.contentOffset;
    [self.collectionView hideLingeringCells];
    
    [self setImageViewCenter];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (self.layout.scale != scrollView.zoomScale) {
        self.layout.scale = scrollView.zoomScale;
        [self.layout invalidateLayout];
        self.collectionView.contentOffset = scrollView.contentOffset;
        [self.collectionView hideLingeringCells];
    }
    
    [self setImageViewCenter];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.hidden = NO;
}

@end
