//
//  CDRTranslucentSideBar.m
//  CDRTranslucentSideBar
//
//  Created by UetaMasamichi on 2014/06/16.
//  Copyright (c) 2014年 nscallop. All rights reserved.
//

#import "CDRTranslucentSideBar.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface CDRTranslucentSideBar ()
@property (nonatomic, strong) UIToolbar *translucentView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property CGPoint panStartPoint;
@end

static CDRTranslucentSideBar *sideBar;

@implementation CDRTranslucentSideBar

+(instancetype)sideBar{
    return sideBar;
}

-(instancetype)init{
    self = [super init];
    if(self){
        [self initCDRTranslucentSideBar];
    }
    return self;
}

-(instancetype)initWithDirection:(BOOL)showFromRight{
    self = [super init];
    if(self){
        _showFromRight = showFromRight;
        [self initCDRTranslucentSideBar];
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Initializer
-(void)initCDRTranslucentSideBar{
    _hasShown = false;

    self.sideBarWidth = 200;
    self.animationDuration = 0.25f;
    
    [self initTranslucentView];
    [self initContentView];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGestureRecognizer.minimumNumberOfTouches = 1;
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:self.panGestureRecognizer];

}

-(void)initContentView{
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentView];
}

-(void)initTranslucentView{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        CGRect translucentFrame = CGRectMake(self.showFromRight ? self.view.bounds.size.width : - self.sideBarWidth, 0, self.sideBarWidth, self.view.bounds.size.height);
        self.translucentView = [[UIToolbar alloc] initWithFrame:translucentFrame];
        self.translucentView.frame = translucentFrame;
        self.translucentView.contentMode = _showFromRight ? UIViewContentModeTopRight : UIViewContentModeTopLeft;
        self.translucentView.clipsToBounds = YES;
        self.translucentView.barStyle = UIBarStyleBlack;
        [self.view.layer insertSublayer:self.translucentView.layer atIndex:0];
    }
}

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadView{
    [super loadView];
}


#pragma mark - Layout
-(BOOL)shouldAutorotate{
    return YES;
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if ([self isViewLoaded] && self.view.window != nil) {
        [self layoutSubviews];
    }
}

- (void)layoutSubviews
{
    CGFloat x = self.showFromRight ? self.parentViewController.view.bounds.size.width - self.sideBarWidth : 0;
    self.contentView.frame = CGRectMake(x, 0, self.sideBarWidth, self.parentViewController.view.bounds.size.height);
}

#pragma mark - Accessor
-(void)setTranslucentStyle:(UIBarStyle)translucentStyle{
    self.translucentView.barStyle = translucentStyle;
}

-(UIBarStyle)translucentStyle{
    return self.translucentView.barStyle;
}



#pragma mark - Show
- (void)showInViewController:(UIViewController *)controller animated:(BOOL)animated
{
    if (sideBar != nil)
    {
        [sideBar dismissAnimated:NO];
    }
    
    if ([self.delegate respondsToSelector:@selector(sideBar:willAppear:)])
    {
        [self.delegate sideBar:self willAppear:animated];
    }
    sideBar = self;
    
    [self addToParentViewController:controller callingAppearanceMethods:YES];
    self.view.frame = controller.view.bounds;
    
    CGFloat parentWidth = self.view.bounds.size.width;
    CGRect sideBarFrame = self.view.bounds;
    sideBarFrame.origin.x = self.showFromRight ? parentWidth : -self.sideBarWidth;
    sideBarFrame.size.width = self.sideBarWidth;
    
    self.contentView.frame = sideBarFrame;
    
    sideBarFrame.origin.x = self.showFromRight ? parentWidth - self.sideBarWidth : 0;
    _hasShown = true;
    
    void (^animations)() =
    ^{
        self.contentView.frame = sideBarFrame;
        self.translucentView.frame = sideBarFrame;
    };
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        if (finished && [self.delegate respondsToSelector:@selector(sideBar:didAppear:)])
        {
            [self.delegate sideBar:self didAppear:animated];
        }
    };
    
    if (animated)
    {
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:kNilOptions
                         animations:animations
                         completion:completion];
    }
    else
    {
        animations();
        completion(YES);
    }
}

- (void)showAnimated:(BOOL)animated
{
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (controller.presentedViewController != nil)
    {
        controller = controller.presentedViewController;
    }
    [self showInViewController:controller animated:animated];
}

- (void)show
{
    [self showAnimated:YES];
}


#pragma mark -Show by Pangesture
-(void)startShow:(CGFloat)startX
{
    if (sideBar != nil)
    {
        [sideBar dismissAnimated:NO];
    }

    sideBar = self;
    
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (controller.presentedViewController != nil)
    {
        controller = controller.presentedViewController;
    }
    [self addToParentViewController:controller callingAppearanceMethods:YES];
    self.view.frame = controller.view.bounds;
    
    CGFloat parentWidth = self.view.bounds.size.width;
    
    CGRect sideBarFrame = self.view.bounds;
    sideBarFrame.origin.x = self.showFromRight ? parentWidth : -self.sideBarWidth;
    sideBarFrame.size.width = self.sideBarWidth;
    self.contentView.frame = sideBarFrame;
    self.translucentView.frame = sideBarFrame;
}

-(void)move:(CGFloat)deltaFromStartX
{
    CGRect sideBarFrame = self.contentView.frame;
    CGFloat parentWidth = self.view.bounds.size.width;
    
    if(self.showFromRight)
    {
        CGFloat x = deltaFromStartX;
        if(deltaFromStartX >= self.sideBarWidth)
        {
            x = self.sideBarWidth;
        }
        sideBarFrame.origin.x = parentWidth - x;
    }
    else
    {
        CGFloat x = deltaFromStartX - _sideBarWidth;
        if(x >= 0)
        {
            x = 0;
        }
        sideBarFrame.origin.x = x;
    }
    
    self.contentView.frame = sideBarFrame;
    self.translucentView.frame = sideBarFrame;
}

- (void)showAnimatedFrom:(BOOL)animated deltaX:(CGFloat)deltaXFromStartXToEndX
{
    if ([self.delegate respondsToSelector:@selector(sideBar:willAppear:)])
    {
        [self.delegate sideBar:self willAppear:animated];
    }
    
    CGRect sideBarFrame = self.contentView.frame;
    CGFloat parentWidth = self.view.bounds.size.width;
    
    sideBarFrame.origin.x = self.showFromRight ? parentWidth - sideBarFrame.size.width : 0;
    
    void (^animations)() =
    ^{
        self.contentView.frame = sideBarFrame;
        self.translucentView.frame = sideBarFrame;
    };
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        if (finished && [self.delegate respondsToSelector:@selector(sideBar:didAppear:)])
        {
            [self.delegate sideBar:self didAppear:animated];
        }
    };
    
    if (animated)
    {
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:kNilOptions
                         animations:animations
                         completion:completion];
    }
    else
    {
        animations();
        completion(YES);
    }
}

#pragma mark - Dismiss
- (void)dismiss
{
    [self dismissAnimated:YES];
}

- (void)dismissAnimated:(BOOL)animated
{
    if ([self.delegate respondsToSelector:@selector(sideBar:willDisappear:)])
    {
        [self.delegate sideBar:self willDisappear:animated];
    }
    
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        [self removeFromParentViewControllerCallingAppearanceMethods:YES];
        
        if ([self.delegate respondsToSelector:@selector(sideBar:didDisappear:)])
        {
            [self.delegate sideBar:self didDisappear:animated];
        }
    };
    
    if (animated)
    {
        CGFloat parentWidth = self.view.bounds.size.width;
        CGRect sideBarFrame = self.contentView.frame;
        sideBarFrame.origin.x = self.showFromRight ? parentWidth : -self.sideBarWidth;
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:
         ^{
             self.contentView.frame = sideBarFrame;
             self.translucentView.frame = sideBarFrame;
         }
                         completion:completion];
    }
    else
    {
        completion(YES);
    }
}

- (void)dismissAnimated:(BOOL)animated deltaX:(CGFloat)deltaXFromStartXToEndX
{
    if ([self.delegate respondsToSelector:@selector(sideBar:willDisappear:)])
    {
        [self.delegate sideBar:self willDisappear:animated];
    }
    
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        [self removeFromParentViewControllerCallingAppearanceMethods:YES];
        
        if ([self.delegate respondsToSelector:@selector(sideBar:didDisappear:)])
        {
            [self.delegate sideBar:self didDisappear:animated];
        }
    };
    
    if (animated)
    {
        CGFloat parentWidth = self.view.bounds.size.width;
        CGRect sideBarFrame = self.contentView.frame;
        sideBarFrame.origin.x = self.showFromRight ? parentWidth : - self.sideBarWidth + deltaXFromStartXToEndX;
        sideBarFrame.size.width = 0;
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:
         ^{
             self.contentView.frame = sideBarFrame;
             self.translucentView.frame = sideBarFrame;
         }
                         completion:completion];
    }
    else
    {
        completion(YES);
    }
}

#pragma mark - Gesture Handler
- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.view];
    if (! CGRectContainsPoint(self.contentView.frame, location))
    {
        [self dismissAnimated:YES];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *) recognizer
{
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.panStartPoint = [recognizer locationInView:self.view];
    }
    
    if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint currentPoint = [recognizer locationInView:self.view];
        if(!self.showFromRight)
        {
            [self move:self.sideBarWidth + currentPoint.x - self.panStartPoint.x];
        }
        else
        {
            [self move:self.sideBarWidth + self.panStartPoint.x - currentPoint.x];
        }
    }
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint endPoint = [recognizer locationInView:self.view];
        
        if(!self.showFromRight)
        {
            if(self.panStartPoint.x - endPoint.x < self.sideBarWidth / 3)
            {
                _hasShown = true;
                [self showAnimatedFrom:YES deltaX:endPoint.x - self.panStartPoint.x];
            }
            else
            {
                _hasShown = false;
                [self dismissAnimated:YES deltaX:endPoint.x - self.panStartPoint.x];
            }
        }
        else
        {
            if(self.panStartPoint.x - endPoint.x >= self.sideBarWidth / 3)
            {
                _hasShown = true;
                [self showAnimatedFrom:YES deltaX:self.panStartPoint.x - endPoint.x];
            }
            //Dismiss Sidebar
            else
            {
                _hasShown = false;
                [self dismissAnimated:YES deltaX:self.panStartPoint.x - endPoint.x];
            }
        }
        
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(touch.view != gestureRecognizer.view)
    {
        return false;
    }
    return true;
}

#pragma mark - TableView


#pragma mark - Helper
- (void)addToParentViewController:(UIViewController *)parentViewController callingAppearanceMethods:(BOOL)callAppearanceMethods
{
    if (self.parentViewController != nil)
    {
        [self removeFromParentViewControllerCallingAppearanceMethods:callAppearanceMethods];
    }
    
    if (callAppearanceMethods) [self beginAppearanceTransition:YES animated:NO];
    [parentViewController addChildViewController:self];
    [parentViewController.view addSubview:self.view];
    [self didMoveToParentViewController:self];
    if (callAppearanceMethods) [self endAppearanceTransition];
}

- (void)removeFromParentViewControllerCallingAppearanceMethods:(BOOL)callAppearanceMethods
{
    if (callAppearanceMethods) [self beginAppearanceTransition:NO animated:NO];
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if (callAppearanceMethods) [self endAppearanceTransition];
}

@end
