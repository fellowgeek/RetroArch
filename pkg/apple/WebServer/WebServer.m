//
//  WebServer.m
//  MAME4iOS
//
//  Created by Yoshi Sugawara on 1/15/19.
//  Copyright © 2019 Seleuco. All rights reserved.
//

#import "WebServer.h"
#import "FileDownloader.h"

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
       docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
#elif TARGET_OS_TV
       docsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
              
       NSLog(@"Syncing files from external server.");
       [self fetchFilesFromAPI:@"http://192.168.0.100/retroarch/"];
#endif
        _webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:docsPath];
        _webUploader.allowHiddenItems = YES;
    }
    return self;
}

-(void)fetchFilesFromAPI: (NSString *)apiURL {

   
   NSURL *url = [NSURL URLWithString:apiURL]; // Replace with your API endpoint

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

       if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }

        if (data) {
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

            if (jsonError) {
                NSLog(@"JSON Parsing Error: %@", jsonError.localizedDescription);
                return;
            }

           // Assuming the JSON structure is like {"files": [{"url": "file1.txt", "location": "/path/to/file1"}, ...]}
            NSArray *files = jsonDict[@"files"];

            for (NSDictionary *fileInfo in files) {
                NSString *urlString = fileInfo[@"download_url"];
                NSString *locationString = fileInfo[@"remote_path"];

                NSLog(@"File URL: %@", urlString);
                NSLog(@"File Location: %@", locationString);
               
                FileDownloader *fileDownloader = [[FileDownloader alloc] initWithDestinationDirectory:[self->docsPath stringByAppendingString: locationString]];
                [fileDownloader downloadFileFromURL:[NSURL URLWithString:urlString]];
               
               [NSThread sleepForTimeInterval: 0.1];
            }
        }
    }];

    [task resume];
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
