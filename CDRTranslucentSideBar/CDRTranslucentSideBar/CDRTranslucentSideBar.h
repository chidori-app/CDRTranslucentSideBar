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
- (void)sideBar:(CDRTranslucentSideBar *)sideBar didTapItemAtIndex:(NSIndexPath *)indexPath;
- (void)sideBar:(CDRTranslucentSideBar *)sideBar didEnable:(BOOL)itemEnabled itemAtIndex:(NSIndexPath *)indexPath;
@end

@interface CDRTranslucentSideBar : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat sideBarWidth;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic) BOOL translucent;
@property (nonatomic) UIBarStyle translucentStyle;
@property (nonatomic) CGFloat translucentAlpha;
@property (nonatomic, strong) UIColor *translucentTintColor;
@property (readonly) BOOL hasShown;
@property (readonly) BOOL showFromRight;
@property BOOL isCurrentPanGestureTarget;

@property (nonatomic, weak) id<CDRTranslucentSideBarDelegate> delegate;

- (instancetype)init;
- (instancetype)initWithDirection:(BOOL)showFromRight;

- (void)show;
- (void)showAnimated:(BOOL)animated;
- (void)showInViewController:(UIViewController *)controller animated:(BOOL)animated;

- (void)startShow:(CGFloat)startX;
- (void)move:(CGFloat)deltaFromStartX;
- (void)showAnimatedFrom:(BOOL)animated deltaX:(CGFloat)deltaFromStartXToEndX;

- (void)dismiss;
- (void)dismissAnimated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated deltaX:(CGFloat)deltaXFromStartXToEndX;

- (void)handlePanGestureToShow:(UIPanGestureRecognizer *)recognizer inView:(UIView *)parentView;

@end
