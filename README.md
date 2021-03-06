# GIFLossyCompress

### 同步调用


```objective-c
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

```

### 异步调用

```objective-c
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
```

### 示例

```objective-c
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

    });
```



