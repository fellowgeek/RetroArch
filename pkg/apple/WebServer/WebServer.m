//
//  WebServer.m
//  MAME4iOS
//
//  Created by Yoshi Sugawara on 1/15/19.
//  Copyright © 2019 Seleuco. All rights reserved.
//

#import "WebServer.h"

@implementation WebServer

#pragma mark - singleton method

+(WebServer*)sharedInstance {
    static dispatch_once_t predicate = 0;
    static id sharedObject = nil;
    dispatch_once(&predicate, ^{
       sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

#pragma mark Init

-(instancetype)init {
    if ( self = [super init] ) {
#if TARGET_OS_IOS
        NSString* docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
#elif TARGET_OS_TV
        NSString* docsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSLog(@"Updating BIOS folder.");
        [self copyDirectory:@"BIOS"];

#endif
        _webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:docsPath];
        _webUploader.allowHiddenItems = YES;
    }
    return self;
}

-(void)copyDirectory:(NSString *)directory {
   NSFileManager *fileManager = [NSFileManager defaultManager];
   NSError *error;
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
   NSString *documentsDirectory = [paths objectAtIndex:0];
   NSString *documentDBFolderPath = [documentsDirectory stringByAppendingPathComponent:directory];
   NSString *resourceDBFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:directory];
   
   if (![fileManager fileExistsAtPath:documentDBFolderPath]) {
       //Create Directory!
       [fileManager createDirectoryAtPath:documentDBFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
   } else {
       NSLog(@"Directory exists! %@", documentDBFolderPath);
   }

   NSArray *fileList = [fileManager contentsOfDirectoryAtPath:resourceDBFolderPath error:&error];
   for (NSString *s in fileList) {
      NSLog(@"Trying: %@", s);
      NSString *newFilePath = [documentDBFolderPath stringByAppendingPathComponent:s];
      NSString *oldFilePath = [resourceDBFolderPath stringByAppendingPathComponent:s];
      if (![fileManager fileExistsAtPath:newFilePath]) {
         NSLog(@"Copying: %@", s);
         //File does not exist, copy it
         [fileManager copyItemAtPath:oldFilePath toPath:newFilePath error:&error];
      } else {
         NSLog(@"File exists: %@", newFilePath);
      }
   }
}


-(void)startUploader {
    if ( _webUploader.isRunning ) {
        [_webUploader stop];
    }
    [_webUploader start];
}

-(void)stopUploader {
    [_webUploader stop];
}

@end
