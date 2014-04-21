//
//  JackyCamera.h
//  OpenCVTest
//
//  Created by Jacky <newbdez33@gmail.com> on 17/04/2014.
//  Copyright (c) 2014 Gaurub. All rights reserved.
//

#import <opencv2/highgui/cap_ios.h>

@interface JackyCamera : CvVideoCamera

- (void)updateOrientation;
- (void)layoutPreviewLayer;

@property (nonatomic, retain) CALayer *customPreviewLayer;

@end
