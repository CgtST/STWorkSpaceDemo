//
//  UIImage+Compress.m
//  QNEngine
//
//  Created by Larry on 15/11/26.
//  Copyright © 2015年 Bacai. All rights reserved.
//

#import "UIImage+Compress.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (Compress)
+ (UIImage *)compressImage:(UIImage *)image
             compressRatio:(CGFloat)ratio
{
    return [[self class] compressImage:image compressRatio:ratio maxCompressRatio:0.1f];
}

+ (UIImage *)compressImage:(UIImage *)image compressRatio:(CGFloat)ratio maxCompressRatio:(CGFloat)maxRatio
{
    
    //We define the max and min resolutions to shrink to
    int MIN_UPLOAD_RESOLUTION = 1136 * 640;
    int MAX_UPLOAD_SIZE = 50;
    
    float factor;
    float currentResolution = image.size.height * image.size.width;
    
    //We first shrink the image a little bit in order to compress it a little bit more
    if (currentResolution > MIN_UPLOAD_RESOLUTION) {
        factor = sqrt(currentResolution / MIN_UPLOAD_RESOLUTION) * 2;
        image = [self scaleDown:image withSize:CGSizeMake(image.size.width / factor, image.size.height / factor)];
    }
    
    //Compression settings
    CGFloat compression = ratio;
    CGFloat maxCompression = maxRatio;
    
    //We loop into the image data to compress accordingly to the compression ratio
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > MAX_UPLOAD_SIZE && compression > maxCompression) {
        compression -= 0.10;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    //Retuns the compressed image
    return [[UIImage alloc] initWithData:imageData];
}


+ (UIImage *)compressRemoteImage:(NSString *)url
                   compressRatio:(CGFloat)ratio
                maxCompressRatio:(CGFloat)maxRatio
{
    //Parse the URL
    NSURL *imageURL = [NSURL URLWithString:url];
    
    //We init the image with the rmeote data
    UIImage *remoteImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    
    //Returns the remote image compressed
    return [[self class] compressImage:remoteImage compressRatio:ratio maxCompressRatio:maxRatio];
    
}

+ (UIImage *)compressRemoteImage:(NSString *)url compressRatio:(CGFloat)ratio
{
    return [[self class] compressRemoteImage:url compressRatio:ratio maxCompressRatio:0.1f];
}

+ (UIImage*)scaleDown:(UIImage*)image withSize:(CGSize)newSize
{
    
    //We prepare a bitmap with the new size
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.0);
    
    //Draws a rect for the image
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    //We set the scaled image from the context
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage {
    CGSize imageSize = sourceImage.size;
    CGFloat scale = (CGFloat)imageSize.width / imageSize.height;
    CGFloat targetWidth = imageSize.width;
    CGFloat targetHeight = imageSize.height;
    CGFloat max = 1280;
    NSData *data = UIImageJPEGRepresentation(sourceImage, 0.75);
    if (data.length < 512 * 1024) {
        //小于512k不处理
        return sourceImage;
    }
    
    if (scale >= 3 || scale <= 1 / 3.0) {
        //宽高比大于1：3
        //如果宽高最小值大于2048。把最大的一边设置为我们的最大值(相机的图片一般会大于这个最大值)
        if (MIN(targetWidth, targetHeight) > 2048) {
            if (targetWidth < targetHeight) {
                targetWidth = (targetWidth / targetHeight) * max;
                targetHeight = max;
            }else {
                targetHeight = (targetHeight / targetWidth) * max;
                targetWidth = max;
            }
        }else{
            return sourceImage;
        }
    }else {
        //比较大的大于1280时把最大的缩到1280
        if (MAX(targetWidth, targetHeight) > max) {
            if (targetWidth < targetHeight) {
                targetWidth = (targetWidth / targetHeight) * max;
                targetHeight = max;
            }else {
                targetHeight = (targetHeight / targetWidth) * max;
                targetWidth = max;
            }
        }else{
            return sourceImage;
        }
    }
    
    //    if (scale >= 3 || scale <= 1 / 3.0) {
    //        //宽高比大于1：3，都大小1280时把较小的缩到1280
    //        if (targetWidth > 1280 && targetHeight > 1280) {
    //            if (targetWidth > targetHeight) {
    //                targetWidth = (targetWidth / targetHeight) * 1280;
    //                targetHeight = 1280;
    //            }else {
    //                targetHeight = (targetHeight / targetWidth) * 1280;
    //                targetWidth = 1280;
    //            }
    //        }else{
    //            return sourceImage;
    //        }
    //    }else {
    //        //比较大的大于1280时把最大的缩到1280
    //        if (MAX(targetWidth, targetHeight) > 1280) {
    //            if (targetWidth < targetHeight) {
    //                targetWidth = (targetWidth / targetHeight) * 1280;
    //                targetHeight = 1280;
    //            }else {
    //                targetHeight = (targetHeight / targetWidth) * 1280;
    //                targetWidth = 1280;
    //            }
    //        }else{
    //            return sourceImage;
    //        }
    //    }
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSData *)ExifDataWithImageData:(NSData *)sourceData {
    
    CGImageSourceRef  source ;
    source = CGImageSourceCreateWithData((CFDataRef)sourceData, NULL);
    
    //get all the metadata in the image
    NSDictionary *metadata = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source,0,NULL));
    
    //make the metadata dictionary mutable so we can add properties to it
    NSMutableDictionary *metadataAsMutable = [metadata mutableCopy];
    
    NSMutableDictionary *EXIFDictionary = [[metadataAsMutable objectForKey:(NSString *)kCGImagePropertyExifDictionary]mutableCopy];
    NSMutableDictionary *GPSDictionary = [[metadataAsMutable objectForKey:(NSString *)kCGImagePropertyGPSDictionary]mutableCopy];
    if(!EXIFDictionary) {
        //if the image does not have an EXIF dictionary (not all images do), then create one for us to use
        EXIFDictionary = [NSMutableDictionary dictionary];
    }
    if(!GPSDictionary) {
        GPSDictionary = [NSMutableDictionary dictionary];
    }
    
//    //Setup GPS dict
//    
//    
//    [GPSDictionary setValue:[NSNumber numberWithFloat:_lat] forKey:(NSString*)kCGImagePropertyGPSLatitude];
//    [GPSDictionary setValue:[NSNumber numberWithFloat:_lon] forKey:(NSString*)kCGImagePropertyGPSLongitude];
//    [GPSDictionary setValue:lat_ref forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
//    [GPSDictionary setValue:lon_ref forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
//    [GPSDictionary setValue:[NSNumber numberWithFloat:_alt] forKey:(NSString*)kCGImagePropertyGPSAltitude];
//    [GPSDictionary setValue:[NSNumber numberWithShort:alt_ref] forKey:(NSString*)kCGImagePropertyGPSAltitudeRef];
//    [GPSDictionary setValue:[NSNumber numberWithFloat:_heading] forKey:(NSString*)kCGImagePropertyGPSImgDirection];
//    [GPSDictionary setValue:[NSString stringWithFormat:@"%c",_headingRef] forKey:(NSString*)kCGImagePropertyGPSImgDirectionRef];
    
//    [EXIFDictionary setValue:xml forKey:(NSString *)kCGImagePropertyExifUserComment];
    //add our modified EXIF data back into the image’s metadata
    [metadataAsMutable setObject:EXIFDictionary forKey:(NSString *)kCGImagePropertyExifDictionary];
    [metadataAsMutable setObject:GPSDictionary forKey:(NSString *)kCGImagePropertyGPSDictionary];
    
    CFStringRef UTI = CGImageSourceGetType(source); //this is the type of image (e.g., public.jpeg)
    
    //this will be the data CGImageDestinationRef will write into
    NSMutableData *dest_data = [NSMutableData data];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((CFMutableDataRef)dest_data,UTI,1,NULL);
    
    if(!destination) {
        NSLog(@"***Could not create image destination ***");
    }
    
    //add the image contained in the image source to the destination, overidding the old metadata with our modified metadata
    CGImageDestinationAddImageFromSource(destination,source,0, (CFDictionaryRef) metadataAsMutable);
    
    //tell the destination to write the image data and metadata into our data object.
    //It will return false if something goes wrong
    BOOL success = NO;
    success = CGImageDestinationFinalize(destination);
    
    if(!success) {
        NSLog(@"***Could not create data from image destination ***");
        return nil;
    }
    CFRelease(destination);
    CFRelease(source);
    return dest_data;
    //now we have the data ready to go, so do whatever you want with it
    //here we just write it to disk at the same path we were passed
//    [dest_data writeToFile:file atomically:YES];
    
    //cleanup
    

}

@end
