//
//  PBFlatSegmentedControl.m
//  FlatUIlikeiOS7
//
//  Created by Piotr Bernad on 11.06.2013.
//  Copyright (c) 2013 Piotr Bernad. All rights reserved.
//

#import "PBFlatSegmentedControl.h"

@implementation PBFlatSegmentedControl

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 0.5*self.bounds.size.height;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self apperance];
    }
    return self;
}



- (id)initWithItems:(NSArray *)items itemSize:(CGSize)itemSize cornerRadius:(CGFloat)cornerRadius{
    self =[super initWithItems:items];
    if (self ) {
        self.itemSize =itemSize;
        self.cornerRadius =cornerRadius;
        [self apperance];
        self.layer.cornerRadius =cornerRadius;
    }
    return self;
    
}


- (void)apperance {
    // Set background images
    UIImage *normalBackgroundImage = [Common imageWithColor:[UIColor colorWithRGBHex:0x5676a7] size:CGSizeMake(self.itemSize.width, self.itemSize.height) andRoundSize:self.cornerRadius];
    UIImage *selectedBackgroundImage = [Common imageWithColor:[UIColor colorWithRGBHex:0x234374] size:CGSizeMake(self.itemSize.width, self.itemSize.height) andRoundSize:self.cornerRadius];
    
    NSDictionary *normalAttributes = @{UITextAttributeFont:[UIFont systemFontOfSize:13.0f],UITextAttributeTextColor: [UIColor colorWithRGBHex:0x234374],UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],UITextAttributeTextShadowColor:[UIColor clearColor]};
    [self setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    
    NSDictionary *selectedAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
    [self setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];

    [self setWidth:self.itemSize.width forSegmentAtIndex:0];
    
    
    [self setBackgroundImage:normalBackgroundImage
                    forState:UIControlStateNormal
                  barMetrics:UIBarMetricsDefault];

    [self setBackgroundImage:selectedBackgroundImage
                    forState:UIControlStateSelected
                  barMetrics:UIBarMetricsDefault];
    

    [self setDividerImage:[Common getImageFromColor:[UIColor clearColor]] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
}

@end
