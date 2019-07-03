//
//  GIFCompression.h
//  GIFCompression
//
//  Created by xiaoyu on 2017/12/18.
//  Copyright © 2018年 lenovo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GIFCompressionResult) {
    GIFCompressOK                      = 0,//无错误
    GIFCompressErrorNotInputNameError  = 1,//inputpath格式错误（nil或空字符）
    GIFCompressErrorNotOutputNameError = 2,//outputpath格式错误（nil或空字符）
    GIFCompressErrorNotFoundInput      = 3,//没有找到inputpath
    GIFCompressErrorInputNotGIF        = 4,//inputpath文件不是gif文件
    GIFCompressErrorCompress           = 5,//压缩出问题
};

/**
 压缩GIF图片
 */
@interface GIFCompression : NSObject

typedef void (^GifCompletion) (GIFCompressionResult result,NSString* outputPath);

/**
 单例
 */
+(instancetype)shareInstance;

/**
 异步调用，需要使用单例方法调用

 @param lossylevel 压缩率，范围0-200，压缩率越大，压缩完成文件更小
 @param inputPath 传入图片路径，原始图片
 @param outputPath 压缩后保存图片路径
 @param completion 完成回调
 */
- (void)compressGIFWithLossyLevel:(int)lossylevel
                        inputPath:(NSString *)inputPath
                       outputPath:(NSString *)outputPath
                       completion:(GifCompletion)completion;

/**
 异步调用接口，需要使用单例方法调用

 @param lossylevel 压缩率，范围0-200，压缩率越大，压缩完成文件更小
 @param inputData 传入图片data
 @param outputPath 压缩后保存图片路径
 @param completion 完成回调
 */
- (void)compressGIFWithLossyLevel:(int)lossylevel
                        inputData:(NSData *)inputData
                       outputPath:(NSString *)outputPath
                       completion:(GifCompletion)completion;

/**
 同步调用接口，如果需要压缩多张图片，外部调用需要使用串行队列

 @param lossylevel 压缩率，范围0-200，压缩率越大，压缩完成文件更小
 @param inputData 传入图片data
 @param outputPath 压缩后保存图片路径
 @return 压缩结果，见GIFCompressionResult
 */
+ (GIFCompressionResult)compressGIFWithLossyLevel:(int)lossylevel
                                        inputData:(NSData *)inputData
                                       outputPath:(NSString *)outputPath;

/**
 同步调用接口，如果需要压缩多张图片，外部调用需要使用串行队列
 
 @param lossylevel 压缩率，范围0-200，压缩率越大，压缩完成文件更小
 @param inputPath 传入图片路径，原始图片
 @param outputPath 压缩后保存图片路径
 @return 压缩结果，见GIFCompressionResult
 */
+ (GIFCompressionResult)compressGIFWithLossyLevel:(int)lossylevel
                                        inputPath:(NSString *)inputPath
                                       outputPath:(NSString *)outputPath;
@end
