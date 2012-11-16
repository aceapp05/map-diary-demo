//
//  PhotoEditor.m
//  Two
//
//  Created by vuaj4er on 12/11/16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoEditor.h"

@implementation PhotoEditor

+ (UIImage *)PhotoWindow:(NSArray *)imageArray 
         withOrientation:(PhotoOrientation)orientation 
                   Range:(CGRect)range
{
    NSUInteger num = [imageArray count];
    NSLog(@"count %d", num);
    if (num == 1) {
        UIImage *image = [imageArray lastObject];
        
        UIGraphicsBeginImageContext(CGSizeMake(range.size.width, range.size.height));
        [image drawInRect:CGRectMake(0, 0, range.size.width, range.size.height)];
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
    
    NSLog(@"front %d, end %d", [frontArray count], [endArray count]);
    PhotoOrientation newOrientation;
    CGRect frontRect, endRect;
    if (orientation == PhotoHorizontal) {
        newOrientation = PhotoVertical;
        frontRect = CGRectMake(range.origin.x, range.origin.y, range.size.width / 2, range.size.height);
        endRect = CGRectMake(range.origin.x + range.size.width/2, range.origin.y, range.size.width / 2, range.size.height);
    }
    else if (orientation == PhotoVertical) {
        newOrientation = PhotoHorizontal;
        frontRect = CGRectMake(range.origin.x, range.origin.y, range.size.width, range.size.height / 2);
        endRect = CGRectMake(range.origin.x, range.origin.y + range.size.width/2, range.size.width, range.size.height / 2);
    }
    
    UIImage *frontImage = [PhotoEditor PhotoWindow:frontArray withOrientation:newOrientation Range:frontRect];
    UIImage *endImage = [PhotoEditor PhotoWindow:endArray withOrientation:newOrientation Range:endRect];
    
    //return frontImage;
    UIImage *newImage = [PhotoEditor PhotoCombine:frontImage Image:endImage withOrientation:orientation];
    return newImage;
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
