//
//  ViewController.m
//  CameraDemo
//
//  Created by 侯垒 on 15/3/6.
//  Copyright (c) 2015年 侯垒. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)clickPaiZhaoButton:(id)sender;
- (IBAction)clickDaKaiXiangCeButton:(id)sender;
- (IBAction)clickLuXiangButton:(id)sender;
- (IBAction)clickShanGuanDengButton:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma -mark拍照
- (IBAction)clickPaiZhaoButton:(id)sender {
    
    //判断当前相机的摄像头是否可用.这里SourceType有三个枚举值分别为
    /*
     UIImagePickerControllerSourceTypeCamera:照相机类型
     UIImagePickerControllerSourceTypeSavedPhotosAlbum：打开自定义图片库
     UIImagePickerControllerSourceTypePhotoLibrary：打开系统相册
     */
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //初始化照相机对象
        UIImagePickerController *imagePC=[[UIImagePickerController alloc] init];
       
        
        //设置代理
        imagePC.delegate=self;
        //允许编辑
        imagePC.allowsEditing=YES;
        //指定使用照相机功能
        imagePC.sourceType=UIImagePickerControllerSourceTypeCamera;
        //设置为前置摄像头，必须在上面一句代码的后面
         imagePC.cameraDevice=UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:imagePC animated:YES completion:^{
            
            
            NSLog(@"进入拍照页面");
        }];
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"你当前的摄像头不可用" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    
    
    
}
#pragma -mark相册
- (IBAction)clickDaKaiXiangCeButton:(id)sender {
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
    //创建一个相机的对象
        UIImagePickerController *imagePC=[[UIImagePickerController alloc]init];
        imagePC.delegate=self;
        //指明用相机干什么？
        imagePC.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        imagePC.allowsEditing=YES;
        //这个数组里面存放的有多少种类型，那么打开的相册里面就能看多什么类型的文件，例如：kUTTypeImage图片，kUTTypeMovie视频，kUTTypeMP3。mp3类型
       // NSArray *array=[NSArray arrayWithObjects:(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie ,nil];
        NSArray *array=[NSArray arrayWithObjects:(NSString *)kUTTypeMovie ,nil];

        //打开的多媒体类型
        imagePC.mediaTypes=array;
        
        imagePC.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
       [self presentViewController:imagePC animated:YES completion:^{
           NSLog(@"进入相册页面");
       }];
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"你当前的摄像头不可用" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];

    }
    
    
}
#pragma -mark录像
- (IBAction)clickLuXiangButton:(id)sender {
    
    //创建一个相机的对象
    UIImagePickerController * pickerImage=[[UIImagePickerController alloc]init];
    pickerImage.delegate=self;
    
    //NSArray * array=[NSArray arrayWithObjects:(NSString*)kUTTypeMovie, nil];//只录像
    
    NSArray * array= [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie,(NSString*)kUTTypeImage, nil];//既能拍照、也能录像
    
    pickerImage.mediaTypes=array;//指定摄像头获取数据的类型
    pickerImage.sourceType=UIImagePickerControllerSourceTypeCamera;//指定打开的是相机
    [pickerImage setCameraDevice:UIImagePickerControllerCameraDeviceRear];//设置摄像头初始是前还是后
    pickerImage.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;//(在指定了mediaTypes包含了录像和拍照两者后，可以通过指定该属性来进行录像或拍照的切换)
    pickerImage.cameraFlashMode=UIImagePickerControllerCameraFlashModeOn;//指定闪关灯类型
    
    //自定义摄像头界面
    /*
     UIView * aView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
     [aView setBackgroundColor:[UIColor clearColor]];
     pickerImage.cameraOverlayView=aView;//覆盖系统默认的预览界面
     [pickerImage setShowsCameraControls:NO];//影藏系统所有的标准控制按钮
     */
    [self presentViewController:pickerImage animated:YES completion:nil];

    
}
#pragma -mark闪光灯
- (IBAction)clickShanGuanDengButton:(id)sender {
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device.torchMode == AVCaptureTorchModeOff) {
        //创建 AV session
        AVCaptureSession * session = [[AVCaptureSession alloc]init];
        
        // Create device input and add to current session
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        [session addInput:input];
        
        // Create video output and add to current session
        AVCaptureVideoDataOutput * output = [[AVCaptureVideoDataOutput alloc]init];
        [session addOutput:output];
        
        // Start session configuration
        [session beginConfiguration];
        [device lockForConfiguration:nil];
        
        // Set torch to on
        [device setTorchMode:AVCaptureTorchModeOn];
        
        [device unlockForConfiguration];
        [session commitConfiguration];
        
        // Start the session
        [session startRunning];
        
        // Keep the session around
        [self setAVSession:self.AVSession];
        
    }
}


#pragma -mark选取相册中相片执行的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"123456");
    //获得拍摄的原始照片
    UIImage *image=[info valueForKey:UIImagePickerControllerOriginalImage];
    //如果是刚拍摄的照片就添加到相册中去
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera)
    {
        //将照片保存到相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
    }
    
    
    //如果照片经过编辑之后，可以通过该方法获得
    UIImage *editImage=[info valueForKey:UIImagePickerControllerEditedImage];
    UIImage *saveImage=nil;
    
    if (editImage)
    {
        saveImage=editImage;
    }
    else
    {
        saveImage=image;
    }
    
    self.imageView.image=saveImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    

}

#pragma mark 点击了cancel按钮后执行的方法(默认的cancel按钮是可以用的，一旦我们自己实现了该方法，就得自己调用:dismissViewControllerAnimated:YES completion:nil方法实现收回相机视图)
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"点击了取消按钮！");
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
