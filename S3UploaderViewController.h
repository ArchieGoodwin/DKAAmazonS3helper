/*
 //
 //  Created by Sergey Dikarev on 1/23/13.
 //  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
 //
 */


#import <UIKit/UIKit.h>

@interface S3UploaderViewController:UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
}
+(BOOL)putImage:(NSData *)image andImageID:(NSString *)imageID andFolder:(NSString *)folderName;
+(NSData *)getImage:(NSString *)imageID inFolder:(NSString *)folderName;
+(BOOL) deleteImage:(NSString *)imageID inFolder:(NSString *)folderName;
+(BOOL) createFolder:(NSString *)folderName;
+(BOOL) deleteFolder:(NSString *)folderName;
+(NSString *)putGif:(NSData *)imageData andImageID:(NSString *)imageID andFolder:(NSString *)folderName;
+(NSString *)putVideo:(NSData *)imageData andImageID:(NSString *)imageID andFolder:(NSString *)folderName;
+(BOOL)isImageExists:(NSString *)imageID inFolder:(NSString *)folderName;
@end
