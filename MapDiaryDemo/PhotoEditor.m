//
//  PhotoEditor.m
//  Two
//
//  Created by vuaj4er on 12/11/16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoEditor.h"

@implementation PhotoEditor

#define INTERVAL_LEN 2
#define MAX_REPLACE 0.3

+ (UIImage *)PhotoWindow:(NSArray *)imageArray 
         withOrientation:(PhotoOrientation)orientation 
                   Range:(CGRect)range
{
    NSUInteger num = [imageArray count];
    if (num == 1) {
        UIImage *image = [imageArray lastObject];
        
        UIGraphicsBeginImageContext(CGSizeMake(range.size.width, range.size.height));
        [image drawInRect:CGRectMake(0 + INTERVAL_LEN, 0 + INTERVAL_LEN, range.size.width - 2*INTERVAL_LEN, range.size.height - 2*INTERVAL_LEN)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
    NSUInteger mid = num / 2;
    NSRange frontRange;
    frontRange.location = 0;
    frontRange.length = mid - frontRange.location;
    NSArray *frontArray = [imageArray subarrayWithRange:frontRange];
    
    NSRange endRange;
    endRange.location = mid;
    endRange.length = num - endRange.location;
    NSArray *endArray = [imageArray subarrayWithRange:endRange];
    
    //NSLog(@"front %d, end %d", [frontArray count], [endArray count]);
    PhotoOrientation newOrientation;
    CGRect frontRect, endRect;
    if (orientation == PhotoHorizontal) {
        newOrientation = PhotoVertical;
        CGFloat d = arc4random() % (int)(MAX_REPLACE*range.size.width/2);
        if (frontRange.length < endRange.length) d = -d;
        frontRect = CGRectMake(range.origin.x, range.origin.y, range.size.width/2 + d, range.size.height);
        endRect = CGRectMake(range.origin.x + range.size.width/2 + d, range.origin.y, range.size.width/2 - d, range.size.height);
    }
    else if (orientation == PhotoVertical) {
        newOrientation = PhotoHorizontal;
        CGFloat d = arc4random() % (int)(MAX_REPLACE*range.size.height/2);
        if (frontRange.length < endRange.length) d = -d;
        frontRect = CGRectMake(range.origin.x, range.origin.y, range.size.width, range.size.height/2 + d);
        endRect = CGRectMake(range.origin.x, range.origin.y + range.size.height/2 + d, range.size.width, range.size.height/2 - d);
    }
    
    UIImage *frontImage = [PhotoEditor PhotoWindow:frontArray withOrientation:newOrientation Range:frontRect];
    UIImage *endImage = [PhotoEditor PhotoWindow:endArray withOrientation:newOrientation Range:endRect];
    
    return [PhotoEditor PhotoCombine:frontImage Image:endImage withOrientation:orientation];
}


+ (UIImage *)PhotoCombine:(UIImage *)frontImage
                    Image:(UIImage *)endImage
          withOrientation:(PhotoOrientation)orientation
{
    CGSize size;
    CGRect frontRect, endRect;
    if (orientation == PhotoHorizontal){
        size = CGSizeMake(frontImage.size.width + endImage.size.width, frontImage.size.height);
        frontRect = CGRectMake(0, 0, frontImage.size.width, frontImage.size.height);
        endRect = CGRectMake(frontImage.size.width, 0, endImage.size.width, endImage.size.height);
    }
    else {
        size = CGSizeMake(frontImage.size.width, frontImage.size.height + endImage.size.height);
        frontRect = CGRectMake(0, 0, frontImage.size.width, frontImage.size.height);
        endRect = CGRectMake(0, frontImage.size.height, endImage.size.width, endImage.size.height);
    }
    
    UIGraphicsBeginImageContext(size);
    if (frontImage) [frontImage drawInRect:frontRect];
    if (endImage) [endImage drawInRect:endRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
