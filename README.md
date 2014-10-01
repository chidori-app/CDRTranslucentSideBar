CDRTranslucentSideBar
=====================

CDRTranslucentSideBar is a useful sidebar menu library for iOS. You can craete beautiful blurred sidebar using CDRTranslucentSideBar.

![CDRTranslucentSideBar1](https://raw.githubusercontent.com/chidori-app/CDRTranslucentSideBar/master/CDRTranslucentSideBar1.gif)　　
![CDRTranslucentSideBar2](https://raw.githubusercontent.com/chidori-app/CDRTranslucentSideBar/master/CDRTranslucentSideBar2.gif)


##How To Get Started

###Manual Installation

- Download source code.
- Add CDRTranslucentSideBar.h and CDRTranslucentSideBar.m from CDRTranslucentSideBar folder to your project.

### Installation with CocoaPods
	pod 'CDRTranslucentSideBar'

##Requirements
iOS7.0 or higher.


##Usage

###Set up
Import `CDRTranslucentSideBar.h` into ViewController and create property of sidebar.

```objective-c
#import "CDRTranslucentSideBar.h"

@interface CDRViewController () <CDRTranslucentSideBarDelegate>
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
@property (nonatomic, strong) CDRTranslucentSideBar *rightSideBar;

@end
```

###Initialize
Initialize the sidebar and set properties in viewDidLoad.
```objective-c
self.sideBar = [[CDRTranslucentSideBar alloc] init];
self.sideBar.delegate = self;
self.sideBar.tag = 0;

//Example of Right Sidebar
self.rightSideBar = [[CDRTranslucentSideBar alloc] initWithDirectionFromRight:YES];
self.rightSideBar.delegate = self;
self.rightSideBar.translucentStyle = UIBarStyleBlack;
self.rightSideBar.tag = 1;
```

####sideBarWidth
The sideBarWidth value. You can change the sidebar width by changing this value.

####animationDuration
The animation duration value to show sidebar. This property specify the duration to show sidebar by action.

####translucentStyle
CDRTranslucentSideBar uses UIToolbar to provide blur effect. This property specifies its appearance.


###Set Content of Sidebar
Set content of sidebar by `setContentViewInSideBar`.
You can use subclass of UIView for contentView, like UITableView.

```objective-c
//Example of Left Sidebar
UITableView *tableView = [[UITableView alloc] init];
tableView.dataSource = self;
tableView.delegate = self;

// Set ContentView in SideBar
[self.sideBar setContentViewInSideBar:tableView];

``` 


###Show Sidebar
To show the sidebar using BarButtonItem, call show method.

```objective-c
- (IBAction)OnSideBarButtonTapped:(id)sender
{
    [self.sideBar show];
}

```



###Set PanGestureRecognizer
CDRTranslucentSideBar can be shown by pan gesture.
Create `UIPangestureRecognizer` and action to handle the gesture.

```objective-c
UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
   
[self.view addGestureRecognizer:panGestureRecognizer];
```

####PanGesture Handler
Create the action to handle the gesture.

```objective-c
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{

	// if you have left and right sidebar, you can control the pan gesture by start point.
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

	// if you have only one sidebar, do like following

	// self.sideBar.isCurrentPanGestureTarget = YES;
	//[self.sideBar handlePanGestureToShow:recognizer inView:self.view];
}

```

###Delegates
CDRTranslucentSideBar has four delegate methods.

- `- (void)sideBar:(CDRTranslucentSideBar *)sideBar didAppear:(BOOL)animated;`
- `- (void)sideBar:(CDRTranslucentSideBar *)sideBar willAppear:(BOOL)animated;`
- `- (void)sideBar:(CDRTranslucentSideBar *)sideBar didDisappear:(BOOL)animated;`
- `- (void)sideBar:(CDRTranslucentSideBar *)sideBar willDisappear:(BOOL)animated;`

##Example
See the sample project `CDRTranslucentSideBar.xcodeproj`.

##FAQ
###How to add the side bar under navigation bar?
Please check this issue. [don't show navigation bar item of main screen in slide menu like this plese give suggition](https://github.com/chidori-app/CDRTranslucentSideBar/issues/5)


##Credits
CDRTranslucentSideBar was originally created by [Masamichi Ueta](http://www.uetamasamichi.com) in the development of [Chidori](http://chidori.nscallop.jp).

CDRTranslucentSideBar is used in [Chidori](http://chidori.nscallop.jp), iOS application.

##Contact
Ask nscallop on Twitter ([@nscallop](https://twitter.com/nscallop))


##License
CDRTranslucentSideBar is available under the apache 2.0 license. See the LICENSE file for more info.