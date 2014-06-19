//
//  CDRViewController.m
//  CDRTranslucentSideBar
//
//  Created by UetaMasamichi on 2014/06/02.
//  Copyright (c) 2014年 nscallop. All rights reserved.
//

#import "CDRViewController.h"
#import "CDRTranslucentSideBar.h"

@interface CDRViewController () <CDRTranslucentSideBarDelegate>
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
@property (nonatomic, strong) CDRTranslucentSideBar *rightSideBar;

@end

@implementation CDRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.sideBar = [[CDRTranslucentSideBar alloc] init];
    self.sideBar.sideBarWidth = 250;
    self.sideBar.delegate = self;

    self.rightSideBar = [[CDRTranslucentSideBar alloc] initWithDirection:YES];
    self.rightSideBar.delegate = self;

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)OnSideBarButtonTapped:(id)sender
{
    [self.sideBar show];
}

- (IBAction)OnRightSideBarButtonTapped:(id)sender
{
    [self.rightSideBar show];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint startPoint = [recognizer locationInView:self.view];
        
        // Left SideBar
        if (startPoint.x < self.view.bounds.size.width / 2.0) {
            self.sideBar.isCurrentPanGestureTarget = YES;
        }
        // Right SideBar
        else {
            self.rightSideBar.isCurrentPanGestureTarget = YES;
        }
    }
    
    [self.sideBar handlePanGestureToShow:recognizer inView:self.view];
    [self.rightSideBar handlePanGestureToShow:recognizer inView:self.view];
}

#pragma mark - CDRTranslucentSideBarDelegate
-(void)sideBar:(CDRTranslucentSideBar *)sideBar didAppear:(BOOL)animated{
    NSLog(@"SideBar did appear");
}

-(void)sideBar:(CDRTranslucentSideBar *)sideBar willAppear:(BOOL)animated{
    NSLog(@"SideBar will appear");
}

-(void)sideBar:(CDRTranslucentSideBar *)sideBar didDisappear:(BOOL)animated{
    NSLog(@"SideBar did disappear");
}

-(void)sideBar:(CDRTranslucentSideBar *)sideBar willDisappear:(BOOL)animated{
    NSLog(@"SideBar will disappear");
}

@end