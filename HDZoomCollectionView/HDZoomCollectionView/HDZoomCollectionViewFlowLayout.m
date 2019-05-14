//
//  HDZoomCollectionViewFlowLayout.m
//  HDZoomCollectionView
//
//  Created by 邓立兵 on 2019/4/11.
//  Copyright © 2019 harry. All rights reserved.
//

#import "HDZoomCollectionViewFlowLayout.h"

#import <CoreGraphics/CoreGraphics.h>

@interface HDZoomCollectionViewFlowLayout ()

@property (nonatomic, strong) NSMutableArray <UICollectionViewLayoutAttributes *> *hdAttributes;
@property (nonatomic, assign) CGSize contentSize;

@end


@implementation HDZoomCollectionViewFlowLayout

- (instancetype)initItemSize:(CGSize)itemSize columns:(CGFloat)columns itemSpacing:(CGFloat)itemSpacing scale:(CGFloat)scale {
    self = [super init];
    if (self) {
        self.itemSize = itemSize;
        self.columns = columns;
        self.itemSpacing = itemSpacing;
        self.scale = scale;
        
        self.contentSize = CGSizeZero;
        
        self.hdAttributes = [@[] mutableCopy];
    }
    return self;
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (CGSize)contentSizeForScale:(CGFloat)scale {
    CGFloat itemCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat rowCount = ceil((CGFloat)itemCount/(CGFloat)self.columns);
    CGSize sz = CGSizeMake(self.itemSize.width * self.columns + self.itemSpacing * (self.columns - 1), self.itemSize.height * rowCount + self.itemSpacing * (rowCount - 1));
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
    CGSize size = CGSizeApplyAffineTransform(sz, transform);
    return size;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    self.contentSize = [self contentSizeForScale:self.scale];
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    NSInteger columnCount = self.columns;
    [self.hdAttributes removeAllObjects];
    for (int idx=0; idx<itemCount; idx++) {
        CGFloat rowIdx = floor((double)idx / (double)columnCount);
        NSInteger columnIdx =  idx % columnCount;
        CGPoint pt = CGPointMake((self.itemSize.width + self.itemSpacing) * (CGFloat)columnIdx, (self.itemSize.height + self.itemSpacing) * (CGFloat)rowIdx);
        CGRect rect = CGRectMake(pt.x, pt.y, self.itemSize.width, self.itemSize.height);
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        CGAffineTransform transform = CGAffineTransformMakeScale(self.scale, self.scale);
        attr.frame = CGRectApplyAffineTransform(rect, transform);
        [self.hdAttributes addObject:attr];
    }
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;  {
    NSMutableArray *attrs = [NSMutableArray array];
    for (int i=0; i<self.hdAttributes.count; i++) {
        UICollectionViewLayoutAttributes *attr = self.hdAttributes[i];
        if (CGRectIntersectsRect(attr.frame, rect)) {
            [attrs addObject:attr];
        }
    }
    return attrs;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    for (int i=0; i<self.hdAttributes.count; i++) {
        UICollectionViewLayoutAttributes *attr = self.hdAttributes[i];
        BOOL isEqual = ([attr.indexPath compare:indexPath] == NSOrderedSame) ? YES : NO;
        if (isEqual) {
            return attr;
        }
    }
    return nil;
}

@end
