//
//  GIFCompression.m
//  GIFCompression
//
//  Created by jinkai on 2017/12/19.
//  Copyright © 2019年 sohu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GIFCompression.h"
#import "gif_compress.h"
#import "NSData+Ex.h"

@implementation GIFCompression

static GIFCompression* _instance = nil;
static dispatch_queue_t serialQueue;

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
        serialQueue = dispatch_queue_create("com.sohu.gifcompression", DISPATCH_QUEUE_SERIAL);
    }) ;
    
    return _instance ;
}

- (void)compressGIFWithLossyLevel:(int)lossylevel
                        inputPath:(NSString *)inputPath
                       outputPath:(NSString *)outputPath
                       completion:(GifCompletion)completion{
    if (!serialQueue) {
        return;
    }
    dispatch_async(serialQueue, ^{
        NSLog(@"compressGIF:%@",inputPath);
        if (!inputPath || [inputPath isEqualToString:@""]) {
            completion(GIFCompressErrorNotInputNameError,outputPath);
            return;
        }
        
        if (!outputPath || [outputPath isEqualToString:@""]) {
            completion(GIFCompressErrorNotOutputNameError,outputPath);
            return;
        }
        
        NSString *inputDelPath = [inputPath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isExistInput = [fileManager fileExistsAtPath:inputDelPath];
        if (!isExistInput) {
            completion(GIFCompressErrorNotFoundInput,outputPath);
            return;
        }
        
        NSData *inputData = [[NSData alloc] initWithContentsOfFile:inputDelPath];
        uint8_t c;
        [inputData getBytes:&c length:1];
        if (c != 0x47) {
            completion(GIFCompressErrorInputNotGIF,outputPath);
            return;
        }
        
        BOOL isExistOutput = [fileManager fileExistsAtPath:outputPath];
        if (isExistOutput) {
            [fileManager removeItemAtPath:outputPath error:nil];
        }
        
        char *inputChar = (char *)(inputDelPath.UTF8String);
        char *outputChar = (char *)(outputPath.UTF8String);
        
        int result = gif_compress(lossylevel, inputChar, outputChar);
        if (result == 0) {
            completion(GIFCompressOK,outputPath);
            return;
        }
        completion(GIFCompressErrorCompress,outputPath);
        return;
    });
}


- (void)compressGIFWithLossyLevel:(int)lossylevel
                        inputData:(NSData *)inputData
                       outputPath:(NSString *)outputPath
                       completion:(GifCompletion)completion{
    if (!serialQueue) {
        return;
    }
    dispatch_async(serialQueue, ^{
        NSLog(@"compressGIF-outPath:%@",outputPath);
        if (!inputData || inputData.length == 0) {
            completion(GIFCompressErrorNotInputNameError,outputPath);
            return;
        }
        
        if (!outputPath || [outputPath isEqualToString:@""]) {
            completion(GIFCompressErrorNotOutputNameError,outputPath);
            return;
        }
        
        //判断是否GIF
        uint8_t c;
        [inputData getBytes:&c length:1];
        if (c != 0x47) {
            completion(GIFCompressErrorInputNotGIF,outputPath);
            return;
        }
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *dirtail = [NSString stringWithFormat:@"%@",@"/Documents/Images"];
        NSString *dirfull = [NSHomeDirectory() stringByAppendingPathComponent:dirtail];
        if (![fileManager fileExistsAtPath:dirfull]) {
            [fileManager createDirectoryAtPath:dirfull withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *gifImageMd5 = [NSString stringWithFormat:@"%@%@",[inputData md5],@".gif"];
        
        //input
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirfull,gifImageMd5];
        NSString *inputPath = [filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        
        BOOL saveResult = [inputData writeToFile:filePath atomically:YES];
        if (!saveResult) {
            NSLog(@"save to file fail!");
        }
        //output
        BOOL isExistOutput = [fileManager fileExistsAtPath:outputPath];
        if (isExistOutput) {
            [fileManager removeItemAtPath:outputPath error:nil];
        }
        //compress
        char *inputChar = (char *)(inputPath.UTF8String);
        char *outputChar = (char *)(outputPath.UTF8String);
        
        int result = gif_compress(lossylevel, inputChar, outputChar);
        //delete input data saved temp file
        NSError *error;
        [fileManager removeItemAtPath:inputPath error:&error];
        
        if (result == 0) {
            completion(GIFCompressOK,outputPath);
            return;
        }
        completion(GIFCompressErrorCompress,outputPath);
        return;
    });
}

+ (GIFCompressionResult)compressGIFWithLossyLevel:(int)lossylevel
                                        inputData:(NSData *)inputData
                                       outputPath:(NSString *)outputPath{
    if (!inputData || inputData.length == 0) {
        return GIFCompressErrorNotInputNameError;
    }
    
    if (!outputPath || [outputPath isEqualToString:@""]) {
        return GIFCompressErrorNotOutputNameError;
    }
    
    //判断是否GIF
    uint8_t c;
    [inputData getBytes:&c length:1];
    if (c != 0x47) {
        return GIFCompressErrorInputNotGIF;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *dirtail = [NSString stringWithFormat:@"%@",@"/Documents/Images"];
    NSString *dirfull = [NSHomeDirectory() stringByAppendingPathComponent:dirtail];
    if (![fileManager fileExistsAtPath:dirfull]) {
        [fileManager createDirectoryAtPath:dirfull withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *gifImageMd5 = [NSString stringWithFormat:@"%@%@",[inputData md5],@".gif"];
    
    //input
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirfull,gifImageMd5];
    NSString *inputPath = [filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    
    BOOL saveResult = [inputData writeToFile:filePath atomically:YES];
    if (!saveResult) {
        NSLog(@"save to file fail!");
    }
    //output
    BOOL isExistOutput = [fileManager fileExistsAtPath:outputPath];
    if (isExistOutput) {
        [fileManager removeItemAtPath:outputPath error:nil];
    }
    //compress
    char *inputChar = (char *)(inputPath.UTF8String);
    char *outputChar = (char *)(outputPath.UTF8String);
    
    int result = gif_compress(lossylevel, inputChar, outputChar);
    //delete input data saved temp file
    NSError *error;
    [fileManager removeItemAtPath:inputPath error:&error];
    if (result == 0) {
        return GIFCompressOK;
    }
    return GIFCompressErrorCompress;
}

+ (GIFCompressionResult)compressGIFWithLossyLevel:(int)lossylevel
                                        inputPath:(NSString *)inputPath
                                       outputPath:(NSString *)outputPath {
    if (!inputPath || [inputPath isEqualToString:@""]) {
        return GIFCompressErrorNotInputNameError;
    }
    
    if (!outputPath || [outputPath isEqualToString:@""]) {
        return GIFCompressErrorNotOutputNameError;
    }
    
    inputPath = [inputPath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExistInput = [fileManager fileExistsAtPath:inputPath];
    if (!isExistInput) {
        return GIFCompressErrorNotFoundInput;
    }
    
    NSData *inputData = [[NSData alloc] initWithContentsOfFile:inputPath];
    uint8_t c;
    [inputData getBytes:&c length:1];
    if (c != 0x47) {
        return GIFCompressErrorInputNotGIF;
    }
    
    BOOL isExistOutput = [fileManager fileExistsAtPath:outputPath];
    if (isExistOutput) {
        [fileManager removeItemAtPath:outputPath error:nil];
    }
    
    char *inputChar = (char *)(inputPath.UTF8String);
    char *outputChar = (char *)(outputPath.UTF8String);
    
    int result = gif_compress(lossylevel, inputChar, outputChar);
    if (result == 0) {
        return GIFCompressOK;
    }
    return GIFCompressErrorCompress;
}
@end
