//
//  FileDownloader.m
//  RetroArch_iOS13
//
//  Created by Erfan Reed on 11/12/23.
//

#import "FileDownloader.h"

@implementation FileDownloader

- (instancetype)initWithDestinationDirectory:(NSString *)destinationDirectory {
    self = [super init];
    if (self) {
        _destinationDirectory = [destinationDirectory copy];

        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];

        [self createDestinationDirectoryIfNeeded];
    }
    return self;
}

- (void)downloadFileFromURL:(NSURL *)url {
    NSURLSessionDownloadTask *downloadTask = [self.urlSession downloadTaskWithURL:url];
    [downloadTask resume];
}

- (void)createDestinationDirectoryIfNeeded {
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.destinationDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:self.destinationDirectory withIntermediateDirectories:YES attributes:nil error:&error];

        if (error) {
            NSLog(@"Error creating destination directory: %@", error.localizedDescription);
        }
    }
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    // Create a destination URL within the specified directory
    NSURL *destinationURL = [NSURL fileURLWithPath:[self.destinationDirectory stringByAppendingPathComponent:downloadTask.response.suggestedFilename]];

    // Move the downloaded file to the destination URL
    NSError *error = nil;
    if ([[NSFileManager defaultManager] moveItemAtURL:location toURL:destinationURL error:&error]) {
        NSLog(@"File downloaded successfully and saved to %@", destinationURL);
    } else {
        NSLog(@"Error saving file: %@", error.localizedDescription);
    }
}

@end
