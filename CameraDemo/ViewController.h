//
//  ViewController.h
//  CameraDemo
//
//  Created by 侯垒 on 15/3/6.
//  Copyright (c) 2015年 侯垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController : UIViewController
{
    AVCaptureSession * _AVSession;//调用闪光灯的时候创建的类
}

@property(nonatomic,retain)AVCaptureSession * AVSession;

@end

