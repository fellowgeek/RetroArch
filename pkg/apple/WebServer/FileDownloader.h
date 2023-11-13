//
//  FileDownloader.h
//  RetroArch_iOS13
//
//  Created by Erfan Reed on 11/12/23.
//  Copyright © 2023 RetroArch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileDownloader : NSObject <NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, copy) NSString *destinationDirectory;

- (instancetype)initWithDestinationDirectory:(NSString *)destinationDirectory;
- (void)downloadFileFromURL:(NSURL *)url;

@end
