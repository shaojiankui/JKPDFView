//
//  JKFilePreviewer.h
//  JKPDFView
//
//  Created by Jakey on 2016/12/9.
//  Copyright © 2016年 Jakey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@protocol JKFilePreviewerItem <QLPreviewItem>
@required
- (NSURL *)remoteUrl;
@property (readwrite, nonatomic) NSURL * previewItemURL;
@end

@interface JKFilePreviewer : QLPreviewController <QLPreviewControllerDataSource, QLPreviewControllerDelegate, UIDocumentInteractionControllerDelegate>

- (id)initWithURL:(NSURL*)url;

- (id)initWithFile:(id<QLPreviewItem>)file;

- (id)initWithFiles:(NSArray *)theFiles;


+ (BOOL)isFilePreviewingSupported;

@end
