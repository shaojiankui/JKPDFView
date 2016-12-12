//
//  JKPDFView.m
//  JKPDFView
//
//  Created by Jakey on 2016/12/9.
//  Copyright © 2016年 Jakey. All rights reserved.
//

#import "JKPDFView.h"
#import "JKPDFViewItem.h"
@implementation JKPDFView

-(void)readPDFWithPath:(NSString*)path{
    NSURL *pdfURL = [NSURL fileURLWithPath:path];
    self.pdfDocumentRef = CGPDFDocumentCreateWithURL( (__bridge CFURLRef) pdfURL );
    self.numberOfPages = (int)CGPDFDocumentGetNumberOfPages( self.pdfDocumentRef );
    if( self.numberOfPages % 2 ) self.numberOfPages++;
     _currentPageIndex = 1;
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(scaGesture:)];
//    [pinchRecognizer setDelegate:self];
    
    [self.scrollView addGestureRecognizer:pinchRecognizer];
    
    [self setNeedsDisplay];
    [self reloadData];
}
-(void)scaGesture:(id)sender {
    
    [self bringSubviewToFront:[(UIPinchGestureRecognizer*)sender view]];
    
    //当手指离开屏幕时,将lastscale设置为1.0
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        lastScale = 1.0;
        return;
    }
    
    
    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
    
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [[(UIPinchGestureRecognizer*)sender view]setTransform:newTransform];
    lastScale = [(UIPinchGestureRecognizer*)sender scale];
    
    NSLog(@"%zd",lastScale);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buidView];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self buidView];
}
-(void)buidView{
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor grayColor];
    //_scrollView
    [self addSubview:self.scrollView];
    self.clipsToBounds = YES;
    
}
-(void)layoutSubviews{
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _scrollView.contentSize =CGSizeMake(self.frame.size.width, self.frame.size.height*3);
    [self reloadData];
}
#pragma getter method
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
-(void)setCanLoop:(BOOL)canLoop{
    _canLoop = canLoop;
    [self reloadData];
}
-(NSMutableArray *)threeItems{
    if(!_threeItems){
        _threeItems  = [NSMutableArray array];
    }
    return _threeItems;
}

#pragma data handle

-(void)reloadData{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!self.pdfDocumentRef || self.numberOfPages==0) {
        _scrollView.contentSize = CGSizeZero;
        return;
    }

    [self.threeItems removeAllObjects];
    [self.threeItems addObject:@([self getNextPage:_currentPageIndex-1])];
    [self.threeItems addObject:@(_currentPageIndex)];
    [self.threeItems addObject:@([self getNextPage:_currentPageIndex+1])];
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) , self.frame.size.height* 3);
    for (int i = 0; i < [self.threeItems count]; i++) {
        JKPDFViewItem *currentView=[[JKPDFViewItem alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)*i, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        currentView.userInteractionEnabled=YES;
        currentView.tag = 1;
        NSNumber *page = _threeItems[i];
        CGPDFPageRef PDFPage = CGPDFDocumentGetPage(self.pdfDocumentRef, [page intValue]);
        currentView.image = [self readImageWithPDFPage:PDFPage];
        currentView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:currentView];
    }
    [_scrollView setContentOffset:CGPointMake(0, CGRectGetHeight(self.bounds))];
}

-(NSInteger)getNextPage:(NSInteger)currentIndex
{
    NSInteger index;
    if (currentIndex==-1) {
        index = self.numberOfPages-1;
    }else if (currentIndex==self.numberOfPages){
        index = 0;
    }else{
        index = currentIndex;
    }
    return index;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    if (!self.canLoop &&  [self getNextPage:_currentPageIndex-1] == 0) {
          [scrollView setContentOffset:CGPointMake(0, CGRectGetHeight(self.bounds)) animated:NO];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int offsetY = scrollView.contentOffset.y;
 
    if(offsetY >= (2*CGRectGetHeight(self.bounds))) {
        //向上
        _currentPageIndex = [self getNextPage:_currentPageIndex+1];
        [self reloadData];
    }
    if(offsetY <= 0) {
        //向下
        if (!self.canLoop &&  [self getNextPage:_currentPageIndex-1] == 0) {
            return;
        }
        _currentPageIndex = [self getNextPage:_currentPageIndex-1];
        [self reloadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(0, CGRectGetHeight(self.bounds)) animated:YES];
}

- (UIImage*)readImageWithPDFPage:(CGPDFPageRef)PDFPage;
{

//    _PDFPage = PDFPage;
    
    // Determine the size of the PDF page.
    CGRect pageRect = CGPDFPageGetBoxRect(PDFPage, kCGPDFMediaBox);
    CGFloat _PDFScale  = self.frame.size.width/pageRect.size.width;
    pageRect.size = CGSizeMake(pageRect.size.width*_PDFScale, pageRect.size.height*_PDFScale);
    
    
    /*
     Create a low resolution image representation of the PDF page to display before the TiledPDFView renders its content.
     */
//    UIGraphicsBeginImageContext(pageRect.size);
    UIGraphicsBeginImageContextWithOptions(pageRect.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // First fill the background with white.
    CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
    CGContextFillRect(context,pageRect);
    
    CGContextSaveGState(context);
    // Flip the context so that the PDF page is rendered right side up.
    CGContextTranslateCTM(context, 0.0, pageRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
//      CGContextScaleCTM(context, 2.4, 2.4);
    // Scale the context so that the PDF page is rendered at the correct size for the zoom level.
    CGContextScaleCTM(context, _PDFScale,_PDFScale);
    CGContextDrawPDFPage(context, PDFPage);
    CGContextRestoreGState(context);
    
    CGPDFPageRetain(PDFPage);
    CGPDFPageRelease(PDFPage);
    
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return backgroundImage;
}
@end
