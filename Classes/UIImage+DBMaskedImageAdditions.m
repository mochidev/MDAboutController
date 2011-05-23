//
//  UIImage+DBMaskedImageAdditions.m
//  MDAboutControllerDemo
//
//  Created by Dimitri Bouniol on 5/23/11.
//  Copyright 2011 Mochi Development Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Also, it'd be super awesome if you left in the credit line generated
//  automatically by the code that links back to this page :)
//

#import "UIImage+DBMaskedImageAdditions.h"

@implementation UIImage (DBMaskedImageAdditions)

- (UIImage *)maskedImageWithMask:(UIImage *)maskImage
{
    CGImageRef maskImageRef = maskImage.CGImage; 
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskImageRef),
                                        CGImageGetHeight(maskImageRef),
                                        CGImageGetBitsPerComponent(maskImageRef),
                                        CGImageGetBitsPerPixel(maskImageRef),
                                        CGImageGetBytesPerRow(maskImageRef),
                                        CGImageGetDataProvider(maskImageRef), NULL, false);
    
    CGImageRef sourceImage = self.CGImage;
    CGImageRef maskedImage;
    
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(sourceImage);
    
    if (alpha != kCGImageAlphaFirst && alpha != kCGImageAlphaLast && alpha != kCGImageAlphaPremultipliedFirst && alpha != kCGImageAlphaPremultipliedLast) {
        size_t width = CGImageGetWidth(sourceImage);
        size_t height = CGImageGetHeight(sourceImage);
        
        CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,
                                                              8, 0, CGImageGetColorSpace(sourceImage),
                                                              kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
        
        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
        
        CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
        maskedImage = CGImageCreateWithMask(imageRefWithAlpha, mask);
        CGImageRelease(imageRefWithAlpha);
        
        CGContextRelease(offscreenContext);
    } else {
        maskedImage = CGImageCreateWithMask(sourceImage, mask);
    }
    
    UIImage *returnImage = [UIImage imageWithCGImage:maskedImage];
    
    CGImageRelease(maskedImage);
    CGImageRelease(mask);
    
    return returnImage;
}

@end