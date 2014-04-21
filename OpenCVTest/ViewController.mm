//
//  ViewController.m
//  OpenCVTest
//
//  Created by Gaurub on 2/13/13.
//  Copyright (c) 2013 Gaurub. All rights reserved.
//

@implementation UIImage(Crop)

-(UIImage*)cropFromRect:(CGRect)fromRect
{
    fromRect = CGRectMake(fromRect.origin.x * self.scale,
                          fromRect.origin.y * self.scale,
                          fromRect.size.width * self.scale,
                          fromRect.size.height * self.scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, fromRect);
    UIImage* crop = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return crop;
}

@end

#import <opencv2/imgproc/imgproc_c.h>
#import "ViewController.h"

// set this to whichever file you want to use.
NSString* const kFaceCascadeName = @"haarcascade_frontalface_alt";

#ifdef __cplusplus
CascadeClassifier face_cascade;
#endif


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.videoCamera = [[JackyCamera alloc] initWithParentView:imageView];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront; //AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288; //AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
    self.videoCamera.imageWidth = self.view.frame.size.width;
    self.videoCamera.imageHeight = self.view.frame.size.height;
    [self.videoCamera start];
        
    NSString *faceCascadePath = [[NSBundle mainBundle] pathForResource:kFaceCascadeName
                                                                ofType:@"xml"];
    
#ifdef __cplusplus
    if(!face_cascade.load([faceCascadePath UTF8String])) {
        NSLog(@"Could not load face classifier!");
    }
#endif

	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - Protocol CvVideoCameraDelegate
#ifdef __cplusplus
- (void) processImage:(Mat &)image
{
   
    vector<cv::Rect> faces;
    Mat frame_gray;
    
    cvtColor(image, frame_gray, CV_BGRA2GRAY);
    equalizeHist(frame_gray, frame_gray);
    
    face_cascade.detectMultiScale(frame_gray, faces, 1.1, 2, 0 | CV_HAAR_SCALE_IMAGE, cv::Size(100, 100));
    
    for(unsigned int i = 0; i < faces.size(); ++i) {
        rectangle(image, cv::Point(faces[i].x, faces[i].y),
                  cv::Point(faces[i].x + faces[i].width, faces[i].y + faces[i].height),
                  cv::Scalar(0,255,255));
        
        
        if(i==0) {
            //NSLog(@"face:%i, %i, %i, %i", faces[i].x,faces[i].y,faces[i].width,faces[i].height);
            UIImage *shot = [self imageWithCVMat:image];
            NSLog(@"shot:%f", shot.size.width);
            dispatch_async(dispatch_get_main_queue(), ^{
                img1.image = [shot cropFromRect:CGRectMake(faces[i].x,faces[i].y,faces[i].width,faces[i].height)];
            });
            
        }
        if(i==1) {
            //NSLog(@"face:%i, %i, %i, %i", faces[i].x,faces[i].y,faces[i].width,faces[i].height);
            UIImage *shot = [self imageWithCVMat:image];
            NSLog(@"shot:%f", shot.size.width);
            dispatch_async(dispatch_get_main_queue(), ^{
                img2.image = [shot cropFromRect:CGRectMake(faces[i].x,faces[i].y,faces[i].width,faces[i].height)];
            });
            
        }
        if(i==2) {
            //NSLog(@"face:%i, %i, %i, %i", faces[i].x,faces[i].y,faces[i].width,faces[i].height);
            UIImage *shot = [self imageWithCVMat:image];
            NSLog(@"shot:%f", shot.size.width);
            dispatch_async(dispatch_get_main_queue(), ^{
                img3.image = [shot cropFromRect:CGRectMake(faces[i].x,faces[i].y,faces[i].width,faces[i].height)];
            });
            
        }
        
        
    }
    


}
#endif

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat
{
    
    //cvtColor( cvMat, cvMat, CV_BGR2RGB);
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
    
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                     // Width
                                        cvMat.rows,                                     // Height
                                        8,                                              // Bits per component
                                        8 * cvMat.elemSize(),                           // Bits per pixel
                                        cvMat.step[0],                                  // Bytes per row
                                        colorSpace,                                     // Colorspace
                                        kCGImageAlphaNone | kCGBitmapByteOrderDefault,  // Bitmap info flags
                                        provider,                                       // CGDataProviderRef
                                        NULL,                                           // Decode
                                        false,                                          // Should interpolate
                                        kCGRenderingIntentDefault);                     // Intent
    
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return image;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
