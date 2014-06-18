//
//  CDRViewController.m
//  CDRTranslucentSideBar
//
//  Created by UetaMasamichi on 2014/06/02.
//  Copyright (c) 2014年 nscallop. All rights reserved.
//

#import "CDRViewController.h"
#import "CDRTranslucentSideBar.h"

@interface CDRViewController ()<CDRTranslucentSideBarDelegate>
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;

@end

@implementation CDRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.sideBar = [[CDRTranslucentSideBar alloc] init];
    //self.sideBar.sideBarWidth = 300;
    //self.sideBar.animationDuration = 1.0f;
    self.sideBar.translucent = YES;
    self.sideBar.translucentAlpha = 1.0;
    self.sideBar.translucentStyle = UIBarStyleBlack;
    self.sideBar.translucentTintColor = [UIColor clearColor];
    self.sideBar.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)OnSideBarButtonTapped:(id)sender {
    [self.sideBar show];
}
@end
