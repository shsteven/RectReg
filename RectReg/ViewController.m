//
//  ViewController.m
//  RectReg
//
//  Created by Steve on 12/8/13.
//  Copyright (c) 2013 MB. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.filterSettingsSlider setMinimumValue:0.2];
    [self.filterSettingsSlider setMaximumValue:1.0];
    [self.filterSettingsSlider setValue:0.6];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    
    GPUImageVideoCamera *videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;

    self.camera = videoCamera;
    
//    GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
    GPUImageSobelEdgeDetectionFilter *edgeDetectionFilter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
    
    GPUImageHoughTransformLineDetector *houghTransformLineDetectorFilter = [[GPUImageHoughTransformLineDetector alloc] init];
    [houghTransformLineDetectorFilter setLineDetectionThreshold:0.6];
    self.transformLineDetector = houghTransformLineDetectorFilter;
    
    
    GPUImageView *filteredVideoView = self.filteredVideoView;
    
    // Add the view somewhere so it's visible
    
//    [videoCamera addTarget:edgeDetectionFilter];
//    [edgeDetectionFilter addTarget:filteredVideoView];
//    [edgeDetectionFilter addTarget:houghTransformLineDetectorFilter];
    
    [videoCamera addTarget:houghTransformLineDetectorFilter];
//    [houghTransformLineDetectorFilter addTarget:filteredVideoView];
    
    
    
    
    
    GPUImageLineGenerator *lineGenerator = [[GPUImageLineGenerator alloc] init];
    //            lineGenerator.crosshairWidth = 15.0;
    [lineGenerator forceProcessingAtSize:CGSizeMake(720.0, 1280.0)];
    [lineGenerator setLineColorRed:1.0 green:0.0 blue:0.0];
    [houghTransformLineDetectorFilter setLinesDetectedBlock:^(GLfloat* lineArray, NSUInteger linesDetected, CMTime frameTime){
        [lineGenerator renderLinesFromArray:lineArray count:linesDetected frameTime:frameTime];
    }];
    
    GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    [blendFilter forceProcessingAtSize:CGSizeMake(720.0, 1280.0)];
    GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
    [videoCamera addTarget:gammaFilter];
    [gammaFilter addTarget:blendFilter];
    
    [lineGenerator addTarget:blendFilter];
    
    [blendFilter addTarget:filteredVideoView];
    
    
    
    
    
//    [videoCamera addTarget:filteredVideoView];
    
    [videoCamera startCameraCapture];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (IBAction)sliderValueChanged:(id)sender {
    [self.transformLineDetector setLineDetectionThreshold:[(UISlider *)sender value]];
}


@end
