//
//  CDRTranslucentSideBar.m
//  CDRTranslucentSideBar
//
//  Created by UetaMasamichi on 2014/06/16.
//  Copyright (c) 2014年 nscallop. All rights reserved.
//

#import "CDRTranslucentSideBar.h"

@interface CDRTranslucentSideBar ()
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
        self.showFromRight = showFromRight;
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
    CGFloat x = self.showFromRight ? self.parentViewController.view.bounds.size.width - self.sideBarWitdh : 0;
    self.tableView.frame = CGRectMake(x, 0, self.sideBarWitdh, self.parentViewController.view.bounds.size.height);
}

#pragma mark - Show

#pragma mark - Dismiss

#pragma mark - Gesture Handler

#pragma mark - TableView


@end
