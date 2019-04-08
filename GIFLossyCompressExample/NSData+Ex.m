//
//  NSData+Ex.m
//  sohuhy
//
//  Created by ZYSu on 2018/11/19.
//  Copyright © 2018年 sohu. All rights reserved.
//

#import "NSData+Ex.h"
#import <CoreServices/CoreServices.h>

@implementation NSData (Ex)

+ (NSData *)compressWithGifData:(NSData *)gifData scale:(float)scale
{
    CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
    size_t count = CGImageSourceGetCount(sourceRef);
    
    CFMutableDataRef newDataRef = CFDataCreateMutable(CFAllocatorGetDefault(), 0);
    CGImageDestinationRef destinationRef = CGImageDestinationCreateWithData(newDataRef, kUTTypeGIF, count, NULL);
    CGImageDestinationSetProperties(destinationRef, CGImageSourceCopyProperties(sourceRef, NULL));
    for (size_t i = 0; i < count; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(sourceRef, i, NULL);
        CGImageRef newImageRef = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageWithCGImage:imageRef], scale)].CGImage;
        CGImageDestinationAddImage(destinationRef, newImageRef, CGImageSourceCopyPropertiesAtIndex(sourceRef, i, NULL));
        CGImageRelease(imageRef);
    }
    CFRelease(sourceRef);
    CGImageDestinationFinalize(destinationRef);
    CFRelease(destinationRef);
    return (__bridge_transfer NSData *)newDataRef;
}

@end
