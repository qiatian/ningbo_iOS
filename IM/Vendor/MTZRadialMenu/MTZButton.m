//
//  MTZButton.m
//
//  Created by Matt Zanchelli on 6/14/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "MTZButton.h"

@implementation MTZButton

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	return CGRectContainsPoint(self.bounds, point) ? self : nil;
}

@end
