//
//  ViewController.m
//  GIFCompressExample
//
//  Created by xiaoyu on 2017/12/18.
//  Copyright © 2017年 lenovo. All rights reserved.
//

#import "ViewController.h"

#import <GIFCompression/GIFCompression.h>
#import "NSData+Ex.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self compress];
//    [self useSysCompress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)compress{
    
    NSDate* tmpStartData = [NSDate date];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *input = [[NSBundle mainBundle] pathForResource:@"wwwww" ofType:@"gif"];
        
        NSString *dirtail = [NSString stringWithFormat:@"%@",@"/Documents/Images"];
        NSString *dirfull = [NSHomeDirectory() stringByAppendingPathComponent:dirtail];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dirfull]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:dirfull withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *outpath = [[dirfull stringByAppendingPathComponent:@"wwwww-2"] stringByAppendingPathExtension:@"gif"];
        
        NSLog(@"out path :%@",outpath);
        
        
        //LossyLevel越大压缩率越大0-200
        GIFCompressionResult re = [GIFCompression compressGIFWithLossyLevel:150 inputPath:input outputPath:outpath];
        NSLog(@"end result : %d",(long)re);
        
        double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
        NSLog(@"时间间隔 %f 秒", deltaTime);
    });

    
    
    //分辨率500*281 ，80质量， 345KB ，  4.4秒
    //500*261， 80质量 ，9.15秒，   834KB ——》 500KB
    //60质量  10秒
    //90  538
    //压缩体积30%左右，画质肉眼看损失小  9.76秒
    //100
    
    //wwww  ， 17.991541 秒
}

- (void)useSysCompress{
    NSDate* tmpStartData = [NSDate date];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *input = [[NSBundle mainBundle] pathForResource:@"d30b3f066d6d473429fa79988ab093fd" ofType:@"gif"];
        
        NSString *dirtail = [NSString stringWithFormat:@"%@",@"/Documents/Images"];
        NSString *dirfull = [NSHomeDirectory() stringByAppendingPathComponent:dirtail];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dirfull]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:dirfull withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *outpath = [[dirfull stringByAppendingPathComponent:@"d30b3f066d6d473429fa79988ab093fd-2"] stringByAppendingPathExtension:@"gif"];
        
        NSLog(@"out path :%@",outpath);
        
        NSData *inputData = [[NSData alloc] initWithContentsOfFile:input];
        
        NSData *outputData = [NSData compressWithGifData:inputData scale:0.5];
        
        [outputData writeToFile:outpath atomically:NO];
//        //LossyLevel越大压缩率越大0-200
//        GIFCompressionResult re = [GIFCompression compressGIFWithLossyLevel:190 inputPath:input outputPath:outpath];
//        NSLog(@"end result : %d",(long)re);
        
        
        double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
        NSLog(@"时间间隔 %f 秒", deltaTime);
    });
}
@end

