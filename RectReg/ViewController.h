//
//  ViewController.h
//  RectReg
//
//  Created by Steve on 12/8/13.
//  Copyright (c) 2013 MB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet GPUImageView *filteredVideoView;
@property (strong) GPUImageVideoCamera *camera;
@property (strong, nonatomic) IBOutlet UISlider *filterSettingsSlider;

@property (strong) GPUImageHoughTransformLineDetector *transformLineDetector;

@end
