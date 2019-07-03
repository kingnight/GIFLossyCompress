//
//  NSData+Ex.m
//  sohuhy
//
//  Created by ZYSu on 2018/11/19.
//  Copyright © 2018年 sohu. All rights reserved.
//

#import "NSData+Ex.h"
#import <CoreServices/CoreServices.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (Ex)


/**
 此方法有问题，不要使用

 @param gifData <#gifData description#>
 @param scale <#scale description#>
 @return <#return value description#>
 */
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


- (NSString *)md5 {
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(self.bytes, (unsigned int)self.length, md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}
@end
