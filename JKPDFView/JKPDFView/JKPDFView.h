//
//  JKPDFView.h
//  JKPDFView
//
//  Created by Jakey on 2016/12/9.
//  Copyright © 2016年 Jakey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKPDFView : UIView<UIScrollViewDelegate>
{
    NSInteger _currentPageIndex;
    CGSize _fitSize;
    CGFloat lastScale;
}
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSMutableArray *threeItems;
@property(nonatomic,assign)  CGPDFDocumentRef pdfDocumentRef;
@property(nonatomic,assign)  BOOL canLoop;
@property(nonatomic,assign)  int numberOfPages;

-(void)readPDFWithPath:(NSString*)path;
@end
