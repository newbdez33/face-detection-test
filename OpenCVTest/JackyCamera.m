//
//  JackyCamera.m
//  OpenCVTest
//
//  Created by Jacky <newbdez33@gmail.com> on 17/04/2014.
//  Copyright (c) 2014 Gaurub. All rights reserved.
//

#import "JackyCamera.h"

@implementation JackyCamera

- (void)updateOrientation;
{
    // nop
}
- (void)layoutPreviewLayer;
{
    if (self.parentView != nil) {
        CALayer* layer = self.customPreviewLayer;
        CGRect bounds = self.customPreviewLayer.bounds;
        layer.position = CGPointMake(self.parentView.frame.size.width/2., self.parentView.frame.size.height/2.);
        layer.bounds = bounds;
    }
}

@end
