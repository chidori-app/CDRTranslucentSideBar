//
//  CDRTranslucentSideBar.swift
//  CDRTranslucentSideBar
//
//  Created by UetaMasamichi on 2014/12/28.
//  Copyright (c) 2014年 nscallop. All rights reserved.
//

import UIKit

@objc public protocol CDRTranslucentSideBarDelegate {
    optional func sideBar(sideBar: CDRTranslucentSideBar, didAppear animated: Bool)
    optional func sideBar(sideBar: CDRTranslucentSideBar, willAppear animated: Bool)
    optional func sideBar(sideBar: CDRTranslucentSideBar, didDisappear animated: Bool)
    optional func sideBar(sideBar: CDRTranslucentSideBar, willDisappear animated: Bool)
}

public enum CDRTranslucentSideBarStyle: Int {
    case ExtraLight
    case Light
    case Dark
}

private let defaultSideBarWidth: CGFloat = 200
private let defaultAnimationDuration: Double = 0.25

public class CDRTranslucentSideBar: UIViewController {
    
    //MARK: - Properties
    public weak var delegate: CDRTranslucentSideBarDelegate?
    public let sideBarWidth: CGFloat
    public let animationDuration: Double
    public var isCurrentPanGestureTarget: Bool
    public var tag: UInt
    public var style: CDRTranslucentSideBarStyle
    
    private var _contentView: UIView?
    public var contentView: UIView? {
        get {
            return self._contentView
        }
        set {
            self._contentView?.removeFromSuperview()
            self._contentView = newValue
            self._contentView?.backgroundColor = UIColor.clearColor()
            
            if let contentView = self._contentView {
                self.view.addSubview(contentView)
            }
        }
    }
    
    private(set) var hasShown: Bool
    private(set) var showFromRight: Bool

    //MARK: - Private Members
    private var translucentView: UIView?
    private var tapGestureRecognizer: UITapGestureRecognizer?
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var panStartPoint: CGPoint
    
    //MARK: - Initializer
    public override convenience init () {
        self.init(style: .Dark, showFromRight: false, width: defaultSideBarWidth, animationDuration: defaultAnimationDuration)
    }
    
    public convenience init(style: CDRTranslucentSideBarStyle) {
        self.init(style: style, showFromRight: false, width: defaultSideBarWidth, animationDuration: defaultAnimationDuration)
    }
    
    public convenience init(style: CDRTranslucentSideBarStyle, showFromRight: Bool){
        self.init(style: style, showFromRight: showFromRight, width: defaultSideBarWidth, animationDuration: defaultAnimationDuration)
    }
    
    //Custom Initializer
    public convenience init(style: CDRTranslucentSideBarStyle, showFromRight: Bool, width: CGFloat) {
        self.init(style: style, showFromRight: showFromRight, width: defaultSideBarWidth, animationDuration: defaultAnimationDuration)
    }
    
    public init(style: CDRTranslucentSideBarStyle, showFromRight: Bool, width: CGFloat, animationDuration: Double) {
        self.style = style
        self.showFromRight = showFromRight
        self.sideBarWidth = width
        self.animationDuration = animationDuration
        self.isCurrentPanGestureTarget = false
        self.tag = 0
        self.hasShown = false
        self.panStartPoint = CGPointMake(0, 0)
        super.init()
    }

    public required init(coder aDecoder: NSCoder) {
        self.style = .Dark
        self.showFromRight = false
        self.sideBarWidth = defaultSideBarWidth
        self.animationDuration = defaultAnimationDuration
        self.isCurrentPanGestureTarget = false
        self.tag = 0
        self.hasShown = false
        self.panStartPoint = CGPointMake(0, 0)
        super.init(coder: aDecoder)
        
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.style = .Dark
        self.showFromRight = false
        self.sideBarWidth = defaultSideBarWidth
        self.animationDuration = defaultAnimationDuration
        self.isCurrentPanGestureTarget = false
        self.tag = 0
        self.hasShown = false
        self.panStartPoint = CGPointMake(0, 0)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    //MARK: - View Life Cycle
    public override func viewDidLoad() {
        
        //Create TranslucentView
        if UIDevice.currentDevice().systemVersion.compare("8.0", options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedAscending {
            //for iOS 8 or later
            let blurStyle: UIBlurEffectStyle = UIBlurEffectStyle(rawValue: self.style.rawValue)!
            let blurEffect = UIBlurEffect(style: blurStyle)
            let visualEffectView = UIVisualEffectView(effect: blurEffect)
            let frame = CGRectMake(self.showFromRight ? self.view.bounds.size.width : -self.sideBarWidth, 0, self.sideBarWidth, self.view.bounds.size.height)
            visualEffectView.frame = frame
            visualEffectView.contentMode = self.showFromRight ? .TopRight : .TopLeft
            visualEffectView.clipsToBounds = true
            self.translucentView = visualEffectView
        } else {
            //for iOS 7
            let frame = CGRectMake(self.showFromRight ? self.view.bounds.size.width : -self.sideBarWidth, 0, self.sideBarWidth, self.view.bounds.size.height)
            let toolbar = UIToolbar(frame: frame)
            let barStyle: UIBarStyle = self.style == .Dark ? .Black : .Default
            toolbar.barStyle = barStyle
            toolbar.contentMode = self.showFromRight ? .TopRight : .TopLeft
            toolbar.clipsToBounds = true
            self.translucentView = toolbar
        }
        
        self.view.layer.insertSublayer(self.translucentView!.layer, atIndex: 0)
        
        self.view.backgroundColor = UIColor.clearColor()
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGesture")
        self.tapGestureRecognizer!.delegate = self
        self.view.addGestureRecognizer(self.tapGestureRecognizer!)
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture")
        self.panGestureRecognizer!.minimumNumberOfTouches = 1
        self.panGestureRecognizer!.maximumNumberOfTouches = 1
        self.view.addGestureRecognizer(self.panGestureRecognizer!)
    }
    
    
    //MARK: - Layout
    public override func shouldAutorotate() -> Bool {
        return true
    }
    
    public override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        
        if self.isViewLoaded() && self.view.window != nil {
            self.layoutSubViews()
        }
    }
    
    private func layoutSubViews() {
        if let parent = self.parentViewController {
            let x = self.showFromRight ? parent.view.bounds.width - self.sideBarWidth : 0
            
            self.contentView?.frame = CGRectMake(x, 0, self.sideBarWidth, parent.view.bounds.size.height)
        }
    }
    
    //MARK: - Helper
    private func addToParentController(parentViewController:UIViewController?, callAppearanceMethods: Bool) {
        if self.parentViewController != nil {
            self.removeFromParentviewController(callAppearanceMethods)
        }
        
        if callAppearanceMethods {
            self.beginAppearanceTransition(true, animated: false)
        }
        
        parentViewController?.addChildViewController(self)
        parentViewController?.view.addSubview(self.view)
        self.didMoveToParentViewController(self)
        
        if callAppearanceMethods {
            self.endAppearanceTransition()
        }
    }
    
    private func removeFromParentviewController(callAppearanceMethods: Bool) {
        if callAppearanceMethods {
            self.beginAppearanceTransition(false, animated: false)
        }
        
        self.willMoveToParentViewController(nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        
        if callAppearanceMethods {
            self.endAppearanceTransition()
        }
        
    }
    
    
    //MARK: - Show
    public func show() {
        self.show(true)
    }
    
    public func show(animated: Bool) {
        let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        var controller: UIViewController?
        while rootViewController?.presentedViewController != nil {
            controller = rootViewController?.presentedViewController
        }
        
        if let parentController = controller {
            self.show(inViewController: parentController, animated: animated)
        }
    }
    
    public func show(inViewController controller: UIViewController) {
        self.show(inViewController: controller, animated: true)
    }
    
    public func show(inViewController controller: UIViewController, animated: Bool) {
        
        self.delegate?.sideBar?(self, willAppear: true)
        
        self.addToParentController(controller, callAppearanceMethods: true)
        self.view.frame = controller.view.bounds
        
        let parentWidth = self.view.bounds.size.width
        let startSideBarFrame = CGRectMake(self.showFromRight ? parentWidth : -self.sideBarWidth, self.view.bounds.origin.y, self.sideBarWidth, self.view.bounds.size.height)
        
        self.contentView?.frame = startSideBarFrame
        
        let stopSideBarFrame = CGRectMake(self.showFromRight ? parentWidth - self.sideBarWidth : 0, startSideBarFrame.origin.y, startSideBarFrame.size.width, startSideBarFrame.size.height)
        
        let animations: () -> () = {
            self.contentView?.frame = stopSideBarFrame
            self.translucentView?.frame = stopSideBarFrame
        }
        
        let completion: (Bool) -> () = {(finished: Bool) in
            self.hasShown = true
            self.isCurrentPanGestureTarget = true
            
            if finished {
                self.delegate?.sideBar?(self, didAppear: true)
            }
        }
        
        if animated {
            UIView.animateWithDuration(NSTimeInterval(self.animationDuration),
                animations: animations,
                completion: completion)
        } else {
            animations()
            completion(true)
        }
    }
    
    //MARK: - Dismiss
    public func dismiss() {
        self.dismiss(true)
    }
    
    public func dismiss(animated: Bool) {
        self.delegate?.sideBar?(self, willDisappear: true)
        
        let parentWidth = self.view.bounds.size.width
        let stopSideBarFrame = CGRectMake(self.showFromRight ? parentWidth  : -self.sideBarWidth, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)
        
        let animations: () -> () = {
            self.contentView?.frame = stopSideBarFrame
            self.translucentView?.frame = stopSideBarFrame
        }
        
        let completion: (Bool) -> () = { (finished: Bool) in
            self.removeFromParentviewController(true)
            self.hasShown = false
            self.isCurrentPanGestureTarget = false
            self.delegate?.sideBar?(self, didDisappear: true)
        }
        
        if animated {
            UIView.animateWithDuration(NSTimeInterval(self.animationDuration),
                animations: animations,
                completion: completion)
        } else {
            animations()
            completion(true)
        }
    }
    
    //MARK: - Gesture Handler
    private func handleTapGesture(recognizer: UITapGestureRecognizer) {
        let location = recognizer.locationInView(self.view)
        
        if let frame = self.translucentView?.frame {
            if !CGRectContainsPoint(frame, location) {
                            self.dismiss(true)
            }
        }
    }
    
    private func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        if !self.isCurrentPanGestureTarget {
            return
        }
        
        if recognizer.state == .Began {
            self.panStartPoint = recognizer.locationInView(self.view)
        }
        
        if recognizer.state == .Changed {
            let currentPoint = recognizer.locationInView(self.view)
            
            if !self.showFromRight {
                
            } else {
                
            }
        }
        
        //if recognizer.state = .Ended {
            
        //}
    }
    

    //MARK: - Show by PanGesture
    private func startToShow(startX: CGFloat) {
        
    }
   
}

extension CDRTranslucentSideBar: UIGestureRecognizerDelegate {
    
}
