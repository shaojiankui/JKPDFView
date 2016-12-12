//
//  JKFilePreviewer.m
//  JKPDFView
//
//  Created by Jakey on 2016/12/9.
//  Copyright © 2016年 Jakey. All rights reserved.
//

#import "JKFilePreviewer.h"
@interface JKFilePreviewerItem : NSObject <JKFilePreviewerItem>
@property (nonatomic, strong) NSURL *remoteUrl;
@property (nonatomic, strong, readwrite) NSURL *previewItemURL;
@property (nonatomic, strong, readwrite) NSString *previewItemTitle;
@end
@implementation JKFilePreviewerItem

@end


@interface JKFilePreviewer ()
@property (nonatomic, copy) NSArray * files;
@end
@implementation JKFilePreviewer
#pragma mark - Initializers
- (id)initWithURL:(NSURL*)url {
    JKFilePreviewerItem *item = [[JKFilePreviewerItem alloc]init];
    item.previewItemURL = url;
    //    item.previewItemTitle = url;
    
    JKFilePreviewer * result = [self initWithFiles:@[item]];
    [result setCurrentPreviewItemIndex:0];
    
    return result;
}

- (id)initWithFile:(id<QLPreviewItem>)file {
    
    JKFilePreviewer * result = [self initWithFiles:[NSArray arrayWithObject:file]];
    [result setCurrentPreviewItemIndex:0];
    
    return result;
}

- (id)initWithFiles:(NSArray *)files  {
    NSAssert([files count] > 0, @"Empty file array.");
    
    if ((self = [super init])) {
        [self setFiles:files];
        [self setDataSource:self];
        [self setDelegate:self];
        [self setCurrentPreviewItemIndex:0];
    }
    
    return self;
}

#pragma mark - Utilities


+ (BOOL)isFilePreviewingSupported {
    return (nil != NSClassFromString(@"QLPreviewController"));
}


#pragma mark - QLPreviewControllerDataSource methods.

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return [[self files] count];
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller
                    previewItemAtIndex:(NSInteger)index {
    id<QLPreviewItem> result = [[self files] objectAtIndex:index];
    
    return result;
}


#pragma mark - QLPreviewControllerDelegate methods

- (BOOL)previewController:(QLPreviewController *)controller
            shouldOpenURL:(NSURL *)url
           forPreviewItem:(id<QLPreviewItem>)item {
    return YES;
}

- (void)previewControllerWillDismiss:(QLPreviewController *)controller {
    //NSLog(@"Quick Look will dismiss");
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller {
    //NSLog(@"Quick Look did dismiss");
}


#pragma mark - UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController {
    return [self parentViewController];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
