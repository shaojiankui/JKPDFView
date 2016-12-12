//
//  ViewController.h
//  JKPDFView
//
//  Created by Jakey on 2016/12/8.
//  Copyright © 2016年 Jakey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKPDFView.h"
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet JKPDFView *pdfView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)touched:(id)sender;

@end

