//
//  NSData+Ex.h
//  sohuhy
//
//  Created by ZYSu on 2018/11/19.
//  Copyright © 2018年 sohu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Ex)

+ (NSData *)compressWithGifData:(NSData *)gifData scale:(float)scale;

- (NSString *)md5;

@end

NS_ASSUME_NONNULL_END
