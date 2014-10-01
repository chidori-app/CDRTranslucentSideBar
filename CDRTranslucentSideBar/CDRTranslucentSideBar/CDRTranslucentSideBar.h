//
//  CDRTranslucentSideBar.h
//  CDRTranslucentSideBar
//
//  Created by UetaMasamichi on 2014/06/16.
//  Copyright (c) 2014年 nscallop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDRTranslucentSideBar;
@protocol CDRTranslucentSideBarDelegate <NSObject>
@optional
- (void)sideBar:(CDRTranslucentSideBar *)sideBar didAppear:(BOOL)animated;
- (void)sideBar:(CDRTranslucentSideBar *)sideBar willAppear:(BOOL)animated;
- (void)sideBar:(CDRTranslucentSideBar *)sideBar didDisappear:(BOOL)animated;
- (void)sideBar:(CDRTranslucentSideBar *)sideBar willDisappear:(BOOL)animated;
@end

@interface CDRTranslucentSideBar : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat sideBarWidth;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic) BOOL translucent;
@property (nonatomic) UIBarStyle translucentStyle;
@property (nonatomic) CGFloat translucentAlpha;
@property (nonatomic, strong) UIColor *translucentTintColor;
@property (readonly) BOOL hasShown;
@property (readonly) BOOL showFromRight;
@property BOOL isCurrentPanGestureTarget;
@property NSInteger tag;

@property (nonatomic, weak) id <CDRTranslucentSideBarDelegate> delegate;

- (instancetype)init;
- (instancetype)initWithDirectionFromRight:(BOOL)showFromRight;

- (void)show;
- (void)showAnimated:(BOOL)animated;
- (void)showInViewController:(UIViewController *)controller;
- (void)showInViewController:(UIViewController *)controller animated:(BOOL)animated;

- (void)dismiss;
- (void)dismissAnimated:(BOOL)animated;

- (void)handlePanGestureToShow:(UIPanGestureRecognizer *)recognizer inView:(UIView *)view;
- (void)handlePanGestureToShow:(UIPanGestureRecognizer *)recognizer inViewController:(UIViewController *)controller;

- (void)setContentViewInSideBar:(UIView *)contentView;

@end
