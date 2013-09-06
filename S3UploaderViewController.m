/*
 //
 //  Created by Sergey Dikarev on 1/23/13.
 //  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
 //
 */

#import "S3UploaderViewController.h"

#import <AWSRuntime/AWSRuntime.h>
#import <AWSS3/AWSS3.h>
@implementation S3UploaderViewController

//============================

+(NSData *)getImage:(NSString *)imageID inFolder:(NSString *)folderName
{
    // Initial the S3 Client.
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
    s3.timeout = 1000;

    @try {
        

        NSString *pictName = [NSString stringWithFormat:@"%@%@", imageID, @".jpg"];
        
        S3GetObjectRequest *porr = [[S3GetObjectRequest alloc] initWithKey:pictName withBucket:folderName];
        // Get the image data from the specified s3 bucket and object.
        S3GetObjectResponse *response = [s3 getObject:porr]; 
        
        NSData *imageData = response.body;
        
        return imageData;
        
    }
    @catch (AmazonClientException *exception) {
        return nil;
    }
}



+(BOOL)isImageExists:(NSString *)imageID inFolder:(NSString *)folderName
{
    @try {
        
        AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
        NSString *pictName = [NSString stringWithFormat:@"%@%@", imageID, @".jpg"];
        NSLog(@"Start checking a full size image %@", imageID);

        S3GetObjectMetadataRequest *porr = [[S3GetObjectMetadataRequest alloc] initWithKey:pictName withBucket:folderName];
        
        S3GetObjectResponse *response = [s3 getObjectMetadata:porr];
        
        if(response)
        {
            return YES;
        }
    }
    @catch (AmazonServiceException *ex) {
        NSLog(@"AmazonServiceException in isImageExists %@", ex.description);
        return NO;
    }
    @catch (NSException *exception) {
        NSLog(@"NSException in isImageExists %@", exception.description);
        return NO;
    }
    
    return NO;
}


+(BOOL)putImage:(NSData *)image andImageID:(NSString *)imageID andFolder:(NSString *)folderName
{
    // Initial the S3 Client.
    //NSLog(@"imageId:%@, size: %i", imageID, UIImageJPEGRepresentation(image, 1).length);
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
    s3.timeout = 1000;
    // Convert the image to JPEG data.
    //NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    NSString *pictName = [NSString stringWithFormat:@"%@%@", imageID, @".jpg"];
    
    @try {
        // Upload image data.  Remember to set the content type.
        S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:pictName inBucket:folderName];
        
        por.contentType = @"image/jpeg";
        por.data        = image;
        //NSLog(@"imageId 2: %@, size: %i", imageID, UIImageJPEGRepresentation(image, 1).length);

        // Put the image data into the specified s3 bucket and object.
        [s3 putObject:por];
        return TRUE;
    }
    @catch (AmazonClientException *exception) {
        NSLog(@"AmazonClientException exception:%@", exception.description);
        return FALSE;
    }
}


+(NSString *)putGif:(NSData *)imageData andImageID:(NSString *)imageID andFolder:(NSString *)folderName
{
    // Initial the S3 Client. chaingegifs
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
    s3.timeout = 1000;

    // Convert the image to JPEG data.
    NSString *pictName = [NSString stringWithFormat:@"%@%@", imageID, @".gif"];
    
    @try {
        // Upload image data.  Remember to set the content type.
        S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:pictName inBucket:folderName];
        por.contentType = @"image/gif";
        por.data        = imageData;
        por.cannedACL   = [S3CannedACL publicRead];
        // Put the image data into the specified s3 bucket and object.
        [s3 putObject:por];
        return [NSString stringWithFormat:@"%@%@", GIFURL, pictName];
    }
    @catch (AmazonClientException *exception) {
        return @"";
    }
}

+(NSString *)putVideo:(NSData *)imageData andImageID:(NSString *)imageID andFolder:(NSString *)folderName
{
    // Initial the S3 Client. chaingegifs
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
    s3.timeout = 1000;

    // Convert the image to JPEG data.
    NSString *pictName = [NSString stringWithFormat:@"%@%@", imageID, @".mp4"];
    
    @try {
        // Upload image data.  Remember to set the content type.
        S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:pictName inBucket:folderName];
        por.contentType = @"video/mp4";
        por.data        = imageData;
        por.cannedACL   = [S3CannedACL publicRead];
        // Put the image data into the specified s3 bucket and object.
        [s3 putObject:por];
        return [NSString stringWithFormat:@"%@%@", VIDEOURL, pictName];
    }
    @catch (AmazonClientException *exception) {
        return @"";
    }
}



+(BOOL) deleteImage:(NSString *)imageID inFolder:(NSString *)folderName
{
    // Initial the S3 Client.
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
    
    NSString *pictName = [NSString stringWithFormat:@"%@%@", imageID, @".jpg"];
    @try{
        [s3 deleteObjectWithKey:pictName withBucket:folderName];
      //  [s3 deleteObject:[[[S3DeleteObjectRequest alloc] initWithKey:pictName inBucket:folderName] autorelease]];
        
        return TRUE;
    }
    @catch (AmazonClientException *exception) {
        return FALSE;
    }}

+(BOOL) createFolder:(NSString *)folderName
{
    // Initial the S3 Client.
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
    
    @try {
        [s3 createBucket:[[S3CreateBucketRequest alloc] initWithName:folderName]];
        return TRUE;
    }
    @catch (AmazonClientException *exception) {
        return FALSE;
    }
}

+(BOOL) deleteFolder:(NSString *)folderName
{
    // Initial the S3 Client.
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
    @try {
        NSArray *array = [s3 listObjectsInBucket:folderName];
        NSMutableArray *marray = [[NSMutableArray alloc] initWithArray:array];
        S3DeleteObjectsRequest *request = [[S3DeleteObjectsRequest alloc] init];
        request.objects = marray;
        NSInteger i;
        if (marray!=nil) {
            for (i=0; i<marray.count; i++) {
                [s3 deleteObjectWithKey:[[marray objectAtIndex: i] key] withBucket:folderName];
            }
            //[s3 deleteObjects:request];
        }
        [s3 deleteBucketWithName:folderName];        
        return TRUE;
    }
    @catch (AmazonClientException *exception) {
        return FALSE;
    }
}

//============================



@end
