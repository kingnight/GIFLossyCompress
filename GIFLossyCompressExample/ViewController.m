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
    
    NSArray *gifArr = @[@"baby",@"wwwww",@"f17fa9be30d23ae607d14ac400927fff",@"d30b3f066d6d473429fa79988ab093fd"];
    
    for (NSString *item in gifArr) {
        [self compressWithName:item];
    }
    
//    [self compressWithName:@"baby"];
    
//    [self compressWithName:@"wwwww"];
//    [self useSysCompress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)compressWithName:(NSString *)name{
    
    //NSDate* tmpStartData = [NSDate date];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *input = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        
        NSString *dirtail = [NSString stringWithFormat:@"%@",@"/Documents/Images"];
        NSString *dirfull = [NSHomeDirectory() stringByAppendingPathComponent:dirtail];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dirfull]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:dirfull withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSData *inputData = [NSData dataWithContentsOfFile:input];
        
        NSString *outputName = [NSString stringWithFormat:@"out-%@",name];
        NSString *outpath = [[dirfull stringByAppendingPathComponent:outputName] stringByAppendingPathExtension:@"gif"];
        
        NSLog(@"start outPath:%@",outpath);
        
        //LossyLevel越大压缩率越大0-200
        [[GIFCompression shareInstance] compressGIFWithLossyLevel:150 inputData:inputData outputPath:outpath completion:^(GIFCompressionResult result, NSString *outputPath) {
            if (result == GIFCompressOK) {
                NSLog(@"GIFCompression OK:%@",outputPath);
            }
        }];
        
//        if (re == GIFCompressOK) {
//            NSLog(@"end result : %ld",(long)re);
//
//            double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
//            NSLog(@"时间间隔 %f 秒", deltaTime);
//        }

    });
    
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
        
       // NSData *outputData = [NSData compressWithGifData:inputData scale:0.5];
        
        //[outputData writeToFile:outpath atomically:NO];
//        //LossyLevel越大压缩率越大0-200
//        GIFCompressionResult re = [GIFCompression compressGIFWithLossyLevel:190 inputPath:input outputPath:outpath];
//        NSLog(@"end result : %d",(long)re);
        
        
        double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
        NSLog(@"时间间隔 %f 秒", deltaTime);
    });
}
@end

