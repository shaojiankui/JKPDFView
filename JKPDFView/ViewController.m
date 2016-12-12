//
//  ViewController.m
//  JKPDFView
//
//  Created by Jakey on 2016/12/8.
//  Copyright © 2016年 Jakey. All rights reserved.
//

#import "ViewController.h"
#import "JKFilePreviewer.h"
#import <QuickLook/QuickLook.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *path =  [[NSBundle mainBundle] pathForResource:@"Adobe Acrobat 9.0中文教程" ofType:@"pdf"];
    
    [self.pdfView readPDFWithPath:path];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)touched:(UIButton*)sender {
    NSString *path =  [[NSBundle mainBundle] pathForResource:@"Adobe Acrobat 9.0中文教程" ofType:@"pdf"];
    
     JKFilePreviewer *finder = [[JKFilePreviewer alloc]initWithURL:[NSURL fileURLWithPath:path]];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:finder] animated:YES completion:nil];
    
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        [self.view bringSubviewToFront:self.webView];
//    }else{
//        [self.view bringSubviewToFront:self.pdfView];
//    }
}



@end
