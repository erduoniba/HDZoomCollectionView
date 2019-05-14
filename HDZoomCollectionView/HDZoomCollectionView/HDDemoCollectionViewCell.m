//
//  HDDemoCollectionViewCell.m
//  HDZoomCollectionView
//
//  Created by 邓立兵 on 2019/4/11.
//  Copyright © 2019 harry. All rights reserved.
//

#import "HDDemoCollectionViewCell.h"

@implementation HDDemoCollectionViewCell {
    UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.image = [UIImage imageNamed:@"Demo"];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
}

@end
