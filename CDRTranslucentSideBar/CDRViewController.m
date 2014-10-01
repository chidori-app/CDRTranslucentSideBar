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

- (void)viewDidLoad {
	[super viewDidLoad];

	// Create SideBar and Set Properties
	self.sideBar = [[CDRTranslucentSideBar alloc] init];
	self.sideBar.sideBarWidth = 200;
	self.sideBar.delegate = self;
	self.sideBar.tag = 0;

	// Create Right SideBar
	self.rightSideBar = [[CDRTranslucentSideBar alloc] initWithDirectionFromRight:YES];
	self.rightSideBar.delegate = self;
	self.rightSideBar.translucentStyle = UIBarStyleBlack;
	self.rightSideBar.tag = 1;

	// Add PanGesture to Show SideBar by PanGesture
	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
	[self.view addGestureRecognizer:panGestureRecognizer];

	// Create Content of SideBar
	UITableView *tableView = [[UITableView alloc] init];
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
	v.backgroundColor = [UIColor clearColor];
	[tableView setTableHeaderView:v];
	[tableView setTableFooterView:v];
    
    //If you create UITableViewController and set datasource or delegate to it, don't forget to add childcontroller to this viewController.
    //[[self addChildViewController: @"your view controller"];
	tableView.dataSource = self;
	tableView.delegate = self;

	// Set ContentView in SideBar
	[self.sideBar setContentViewInSideBar:tableView];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (IBAction)OnSideBarButtonTapped:(id)sender {
	[self.sideBar show];
}

- (IBAction)OnRightSideBarButtonTapped:(id)sender {
	[self.rightSideBar showInViewController:self];
}

#pragma mark - Gesture Handler
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
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
	[self.rightSideBar handlePanGestureToShow:recognizer inViewController:self];

	// if you have only one sidebar, do like following

	// self.sideBar.isCurrentPanGestureTarget = YES;
	//[self.sideBar handlePanGestureToShow:recognizer inView:self.view];
}

#pragma mark - CDRTranslucentSideBarDelegate
- (void)sideBar:(CDRTranslucentSideBar *)sideBar didAppear:(BOOL)animated {
	if (sideBar.tag == 0) {
		NSLog(@"Left SideBar did appear");
	}

	if (sideBar.tag == 1) {
		NSLog(@"Right SideBar did appear");
	}
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar willAppear:(BOOL)animated {
	if (sideBar.tag == 0) {
		NSLog(@"Left SideBar will appear");
	}

	if (sideBar.tag == 1) {
		NSLog(@"Right SideBar will appear");
	}
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar didDisappear:(BOOL)animated {
	if (sideBar.tag == 0) {
		NSLog(@"Left SideBar did disappear");
	}

	if (sideBar.tag == 1) {
		NSLog(@"Right SideBar did disappear");
	}
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar willDisappear:(BOOL)animated {
	if (sideBar.tag == 0) {
		NSLog(@"Left SideBar will disappear");
	}

	if (sideBar.tag == 1) {
		NSLog(@"Right SideBar will disappear");
	}
}

// This is just a sample for tableview menu
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	}
	else if (section == 1) {
		return 3;
	}
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		// StatuBar Height
		return 20;
	}
	else if (section == 1) {
		return 44;
	}
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		UIView *clearView = [[UIView alloc] initWithFrame:CGRectZero];
		clearView.backgroundColor = [UIColor clearColor];
		return clearView;
	}
	else if (section == 1) {
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
		headerView.backgroundColor = [UIColor clearColor];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.bounds.size.width - 15, 44)];
		UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 44, tableView.bounds.size.width, 0.5f)];
		separatorLineView.backgroundColor = [UIColor blackColor];
		[headerView addSubview:separatorLineView];
		label.text = @"Chidori";
		[headerView addSubview:label];
		return headerView;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		return 0;
	}
	else if (indexPath.section == 1) {
		return 44;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
		cell.backgroundColor = [UIColor clearColor];
	}

	if (indexPath.section == 0) {
		return cell;
	}
	else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Menu 1";
		}
		else if (indexPath.row == 1) {
			cell.textLabel.text = @"Menu 2";
		}
		else if (indexPath.row == 2) {
			cell.textLabel.text = @"Menu 3";
		}
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

@end
