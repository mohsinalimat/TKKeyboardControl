//
//  TKKeyboardControl.swift
//
//  Created by 辰己 佳祐 on 2016/04/21.
//  Copyright © 2016年 Keisuke Tatsumi. All rights reserved.
//

import UIKit
import Foundation

typealias TKKeyboardDidMoveBlock = ((keyboardFrameInView : CGRect, opening : Bool, closing : Bool) -> Void)?

class TKKeyboardDidMoveBlockWrapper {
    var closure: TKKeyboardDidMoveBlock
    
    init(_ closure: TKKeyboardDidMoveBlock) {
        self.closure = closure
    }
}

class PreviousKeyboardRectWrapper {
    
    var closure: CGRect
    
    init(_ closure: CGRect) {
        self.closure = closure
    }
}

@inline(__always) func AnimationOptionsForCurve(curve: UIViewAnimationCurve) -> UIViewAnimationOptions {
    
    return UIViewAnimationOptions.init(rawValue: UInt(curve.rawValue))
}

extension UIView : UIGestureRecognizerDelegate {

    private struct AssociatedKeys {
        static var DescriptiveTriggerOffset = "DescriptiveTriggerOffset"
        
        static var UIViewKeyboardTriggerOffset = "UIViewKeyboardTriggerOffset";
        static var UIViewKeyboardDidMoveFrameBasedBlock = "UIViewKeyboardDidMoveFrameBasedBlock";
        static var UIViewKeyboardDidMoveConstraintBasedBlock = "UIViewKeyboardDidMoveConstraintBasedBlock";
        static var UIViewKeyboardActiveInput = "UIViewKeyboardActiveInput";
        static var UIViewKeyboardActiveView = "UIViewKeyboardActiveView";
        static var UIViewKeyboardPanRecognizer = "UIViewKeyboardPanRecognizer";
        static var UIViewPreviousKeyboardRect = "UIViewPreviousKeyboardRect";
        static var UIViewIsPanning = "UIViewIsPanning";
        static var UIViewKeyboardOpened = "UIViewKeyboardOpened";
        static var UIViewKeyboardFrameObserved = "UIViewKeyboardFrameObserved";
    }
    
    dynamic var keyboardTriggerOffset : CGFloat {
        
        get {
            guard let triggerOffset: CGFloat = objc_getAssociatedObject(self, &AssociatedKeys.DescriptiveTriggerOffset) as? CGFloat else {
                return 0
            }
            return triggerOffset
        }
        
        set {
            if let newValue : CGFloat = newValue {
                self.willChangeValueForKey("keyboardTriggerOffset");
                objc_setAssociatedObject(self,
                                         &AssociatedKeys.DescriptiveTriggerOffset,
                                         newValue as CGFloat,
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.didChangeValueForKey("keyboardTriggerOffset");
            }
        }
    }
    
    var keyboardWillRecede : Bool {
        
        get {
            let keyboardViewHeight = self.keyboardActiveView!.bounds.size.height
            let keyboardWindowHeight = self.keyboardActiveView!.superview!.bounds.size.height;
            let touchLocationInKeyboardWindow = self.keyboardPanRecognizer!.locationInView(self.keyboardActiveView!.superview!)
            let thresholdHeight = keyboardWindowHeight - keyboardViewHeight - self.keyboardTriggerOffset + 44.0
            let velocity = self.keyboardPanRecognizer!.velocityInView(self.keyboardActiveView)
            
            return touchLocationInKeyboardWindow.y >= thresholdHeight && velocity.y >= 0
        }
    }
    
    private var frameBasedKeyboardDidMoveBlock : TKKeyboardDidMoveBlock {
        
        get {
            guard let cl = objc_getAssociatedObject(self, &AssociatedKeys.UIViewKeyboardDidMoveFrameBasedBlock) as? TKKeyboardDidMoveBlockWrapper else {
                return nil
            }
            return cl.closure
        }
        
        set {
            self.willChangeValueForKey("frameBasedKeyboardDidMoveBlock")
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.UIViewKeyboardDidMoveFrameBasedBlock,
                                     TKKeyboardDidMoveBlockWrapper(newValue),
                                     .OBJC_ASSOCIATION_RETAIN)
            self.didChangeValueForKey("frameBasedKeyboardDidMoveBlock")
        }
    }
    
    private var constraintBasedKeyboardDidMoveBlock : TKKeyboardDidMoveBlock {
        
        get {
            guard let cl = objc_getAssociatedObject(self, &AssociatedKeys.UIViewKeyboardDidMoveConstraintBasedBlock) as? TKKeyboardDidMoveBlockWrapper else {
                return nil
            }
            return cl.closure
        }
        
        set {
            self.willChangeValueForKey("constraintBasedKeyboardDidMoveBlock")
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.UIViewKeyboardDidMoveConstraintBasedBlock,
                                     TKKeyboardDidMoveBlockWrapper(newValue),
                                     .OBJC_ASSOCIATION_RETAIN)
            self.didChangeValueForKey("constraintBasedKeyboardDidMoveBlock")
        }
    }
    
    private var keyboardActiveInput : UIResponder? {
        
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.UIViewKeyboardActiveInput) as? UIResponder
        }
        
        set {
            if let newValue : UIResponder = newValue {
                self.willChangeValueForKey("keyboardActiveInput")
                objc_setAssociatedObject(self,
                                         &AssociatedKeys.UIViewKeyboardActiveInput,
                                         newValue as UIResponder,
                                         .OBJC_ASSOCIATION_RETAIN)
                self.didChangeValueForKey("keyboardActiveInput")
            }
        }
    }
    
    private var keyboardActiveView : UIView? {
        
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.UIViewKeyboardActiveView) as? UIView
        }
        
        set {
            if let newValue : UIView = newValue {
                self.willChangeValueForKey("keyboardActiveView")
                objc_setAssociatedObject(self,
                                         &AssociatedKeys.UIViewKeyboardActiveView,
                                         newValue as UIView,
                                         .OBJC_ASSOCIATION_RETAIN)
                self.didChangeValueForKey("keyboardActiveView")
            }
        }
    }
    
    private var keyboardPanRecognizer : UIPanGestureRecognizer? {
        
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.UIViewKeyboardPanRecognizer) as? UIPanGestureRecognizer
        }
        
        set {
            if let newValue : UIPanGestureRecognizer = newValue {
                self.willChangeValueForKey("keyboardPanRecognizer")
                objc_setAssociatedObject(self,
                                         &AssociatedKeys.UIViewKeyboardPanRecognizer,
                                         newValue as UIPanGestureRecognizer,
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.didChangeValueForKey("keyboardPanRecognizer")
            }
        }
    }
    
    private var previousKeyboardRect : CGRect {
        
        get {
            guard let cl = objc_getAssociatedObject(self, &AssociatedKeys.UIViewPreviousKeyboardRect) as? PreviousKeyboardRectWrapper else {
                return CGRectZero
            }
            return cl.closure
        }
        
        set {
            self.willChangeValueForKey("previousKeyboardRect")
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.UIViewPreviousKeyboardRect,
                                     PreviousKeyboardRectWrapper(newValue),
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.didChangeValueForKey("previousKeyboardRect")
        }
    }
    
    private var panning : Bool {
        
        get {
            guard let isPanningNumber: NSNumber = objc_getAssociatedObject(self, &AssociatedKeys.UIViewIsPanning) as? NSNumber else {
                return false
            }
            return isPanningNumber.boolValue
        }
        
        set {
            if let newValue : Bool = newValue {
                self.willChangeValueForKey("panning");
                objc_setAssociatedObject(self,
                                         &AssociatedKeys.UIViewIsPanning,
                                         NSNumber(bool: newValue),
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.didChangeValueForKey("panning");
            }
        }
    }
    
    private var keyboardOpened : Bool {
        
        get {
            guard let isKeyboardOpenedNumber: NSNumber = objc_getAssociatedObject(self, &AssociatedKeys.UIViewKeyboardOpened) as? NSNumber else {
                return false
            }
            return isKeyboardOpenedNumber.boolValue
        }
        
        set {
            if let newValue : Bool = newValue {
                self.willChangeValueForKey("keyboardOpened");
                objc_setAssociatedObject(self,
                                         &AssociatedKeys.UIViewKeyboardOpened,
                                         NSNumber(bool: newValue),
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.didChangeValueForKey("keyboardOpened");
            }
        }
    }
    
    private var keyboardFrameObserved : Bool {
        
        get {
            guard let isKeyboardFrameObservedNumber: NSNumber = objc_getAssociatedObject(self, &AssociatedKeys.UIViewKeyboardFrameObserved) as? NSNumber else {
                return false
            }
            return isKeyboardFrameObservedNumber.boolValue
        }
        
        set {
            if let newValue : Bool = newValue {
                self.willChangeValueForKey("keyboardFrameObserved");
                objc_setAssociatedObject(self,
                                         &AssociatedKeys.UIViewKeyboardFrameObserved,
                                         NSNumber(bool: newValue),
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.didChangeValueForKey("keyboardFrameObserved");
            }
        }
    }
    
    public override class func initialize() {
        
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        if self !== UIView.self {
            return
        }
        
        dispatch_once(&Static.token) {
            let originalSelector = #selector(UIView.addSubview(_:))
            let swizzledSelector = #selector(UIView.swizzled_addSubview(_:))
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
    
// MARK: - Public Methods
    
    func addKeyboardPanningWithFrameBasedActionHandler(frameBasedActionHandler: TKKeyboardDidMoveBlock, constraintBasedActionHandler: TKKeyboardDidMoveBlock) {
        
        self.addKeyboardControl(true, frameBasedActionHandler: frameBasedActionHandler, constraintBasedActionHandler: constraintBasedActionHandler)
    }
    
    func addKeyboardNonpanningWithFrameBasedActionHandler(frameBasedActionHandler: TKKeyboardDidMoveBlock, constraintBasedActionHandler: TKKeyboardDidMoveBlock) {
        
        self.addKeyboardControl(false, frameBasedActionHandler: frameBasedActionHandler, constraintBasedActionHandler: constraintBasedActionHandler)
    }
    
    func addKeyboardControl(panning: Bool, frameBasedActionHandler: TKKeyboardDidMoveBlock, constraintBasedActionHandler: TKKeyboardDidMoveBlock) {
        
        if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0 {
            if panning && self.respondsToSelector(Selector("keyboardDismissMode")) {
                if let scrollView = self as? UIScrollView {
                    scrollView.keyboardDismissMode = .Interactive
                }
            }
        }
        
        self.panning = panning
        
        self.frameBasedKeyboardDidMoveBlock = frameBasedActionHandler
        self.constraintBasedKeyboardDidMoveBlock = constraintBasedActionHandler
        
        // Register for text input notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIView.responderDidBecomeActive(_:)), name: UITextFieldTextDidBeginEditingNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIView.responderDidBecomeActive(_:)), name: UITextViewTextDidBeginEditingNotification, object: nil)
        
        // Register for keyboard notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIView.inputKeyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIView.inputKeyboardDidShow), name: UIKeyboardDidShowNotification, object: nil)
        
        // For the sake of 4.X compatibility
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIView.inputKeyboardWillChangeFrame(_:)), name: "UIKeyboardWillChangeFrameNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIView.inputKeyboardDidChangeFrame), name: "UIKeyboardDidChangeFrameNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIView.inputKeyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIView.inputKeyboardDidHide), name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func keyboardFrameInView() -> CGRect {
        
        if self.keyboardActiveView != nil {
            
            let keyboardFrameInView = self.convertRect(self.keyboardActiveView!.frame, fromView: self.keyboardActiveView?.superview)
            return keyboardFrameInView
        }
        else {
            let keyboardFrameInView = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, 0, 0)
            return keyboardFrameInView
        }
    }
    
    func removeKeyboardControl() {
        
        // Unregister for text input notifications
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidBeginEditingNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidBeginEditingNotification, object: nil)
        
        // Unregister for keyboard notifications
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        
        // For the sake of 4.X compatibility
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "UIKeyboardWillChangeFrameNotification", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "UIKeyboardDidChangeFrameNotification", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
        
        // Unregister any gesture recognizer
        self.removeGestureRecognizer(self.keyboardPanRecognizer!)
        
        // Release a few properties
        self.frameBasedKeyboardDidMoveBlock = nil;
        self.keyboardActiveInput = nil;
        self.keyboardActiveView = nil;
        self.keyboardPanRecognizer = nil;
    }
    
    func hideKeyboard() {
        
        if self.keyboardActiveView != nil {
            self.keyboardActiveView!.hidden = true
            self.keyboardActiveView!.userInteractionEnabled = false
            self.keyboardActiveInput!.resignFirstResponder()
        }
    }
    
// MARK: - Input Notifications
    
    func responderDidBecomeActive(notification: NSNotification) {
        
        self.keyboardActiveInput = notification.object as? UIResponder
        if self.keyboardActiveInput!.inputAccessoryView == nil {
            
            let textField = self.keyboardActiveInput as! UITextField
            if textField.respondsToSelector(Selector("inputAccessoryView")) {
                let nullView: UIView = UIView(frame: CGRectZero)
                nullView.backgroundColor = .clearColor()
                textField.inputAccessoryView = nullView
            }
            self.keyboardActiveInput = textField as UIResponder
            self.inputKeyboardDidShow()
        }
    }
    
// MARK: - Keyboard Notifications
    
    func inputKeyboardWillShow(notification: NSNotification) {
        
        var keyboardEndFrameWindow: CGRect = CGRect()
        notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.getValue(&keyboardEndFrameWindow)
        
        var keyboardTransitionDuration: Double = Double()
        notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.getValue(&keyboardTransitionDuration)
        
        var keyboardTransitionAnimationCurve: UIViewAnimationCurve = UIViewAnimationCurve(rawValue:0)!
        notification.userInfo![UIKeyboardAnimationCurveUserInfoKey]?.getValue(&keyboardTransitionAnimationCurve)
        
        self.keyboardActiveView?.hidden = false
        self.keyboardOpened = true
        
        let keyboardEndFrameView = self.convertRect(keyboardEndFrameWindow, fromView: nil)
        
        let constraintBasedKeyboardDidMoveBlockCalled = (self.constraintBasedKeyboardDidMoveBlock != nil && !CGRectIsNull(keyboardEndFrameView))
        
        if constraintBasedKeyboardDidMoveBlockCalled {
            
            self.constraintBasedKeyboardDidMoveBlock!(keyboardFrameInView: keyboardEndFrameView, opening: true, closing: false)
        }
        
        UIView.animateWithDuration(keyboardTransitionDuration,
                                   delay: 0,
                                   options: [AnimationOptionsForCurve(keyboardTransitionAnimationCurve), .BeginFromCurrentState],
                                   animations: {
                                    
                                    if constraintBasedKeyboardDidMoveBlockCalled {
                                        self.layoutIfNeeded()
                                    }
                                    if self.frameBasedKeyboardDidMoveBlock != nil && !CGRectIsNull(keyboardEndFrameView) {
                                        self.frameBasedKeyboardDidMoveBlock!(keyboardFrameInView: keyboardEndFrameView, opening: true, closing: false)
                                    }
        }) { (finished: Bool) in
            if self.panning {
                
                self.keyboardPanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(UIView.panGestureDidChange(_:)))
                self.keyboardPanRecognizer?.minimumNumberOfTouches = 1
                self.keyboardPanRecognizer?.delegate = self
                self.keyboardPanRecognizer?.cancelsTouchesInView = false
                self.addGestureRecognizer(self.keyboardPanRecognizer!)
            }
        }
    }
    
    func inputKeyboardDidShow() {
        self.keyboardActiveView = self.findInputSetHostView()
        self.keyboardActiveView?.hidden = false
        
        if self.keyboardActiveView == nil {
            
            self.keyboardActiveInput = self.recursiveFindFirstResponder(self)
            self.keyboardActiveView = self.findInputSetHostView()
            self.keyboardActiveView?.hidden = false
        }
        
        if !self.keyboardFrameObserved {
            self.keyboardActiveView!.addObserver(self, forKeyPath: "frame", options: .New, context: nil)
            self.keyboardFrameObserved = true
        }
    }

    func inputKeyboardWillChangeFrame(notification: NSNotification) {
        
        var keyboardEndFrameWindow: CGRect = CGRect()
        notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.getValue(&keyboardEndFrameWindow)
        
        var keyboardTransitionDuration: Double = Double()
        notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.getValue(&keyboardTransitionDuration)
        
        var keyboardTransitionAnimationCurve: UIViewAnimationCurve = UIViewAnimationCurve(rawValue:0)!
        notification.userInfo![UIKeyboardAnimationCurveUserInfoKey]?.getValue(&keyboardTransitionAnimationCurve)
        
        let keyboardEndFrameView = self.convertRect(keyboardEndFrameWindow, fromView: nil)
        
        let constraintBasedKeyboardDidMoveBlockCalled = (self.constraintBasedKeyboardDidMoveBlock != nil && !CGRectIsNull(keyboardEndFrameView))
        
        if constraintBasedKeyboardDidMoveBlockCalled {
            
            self.constraintBasedKeyboardDidMoveBlock!(keyboardFrameInView: keyboardEndFrameView, opening: false, closing: false)
        }
        
        UIView.animateWithDuration(keyboardTransitionDuration,
                                   delay: 0,
                                   options: [AnimationOptionsForCurve(keyboardTransitionAnimationCurve), .BeginFromCurrentState],
                                   animations: {
                                    
                                    if constraintBasedKeyboardDidMoveBlockCalled {
                                        self.layoutIfNeeded()
                                    }
                                    if self.frameBasedKeyboardDidMoveBlock != nil && !CGRectIsNull(keyboardEndFrameView) {
                                        self.frameBasedKeyboardDidMoveBlock!(keyboardFrameInView: keyboardEndFrameView, opening: false, closing: false)
                                    }
        }, completion:nil)
    }
    
    func inputKeyboardDidChangeFrame() {
        // Nothing to see here
    }
    
    func inputKeyboardWillHide(notification: NSNotification) {
        
        var keyboardEndFrameWindow: CGRect = CGRect()
        notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.getValue(&keyboardEndFrameWindow)
        
        var keyboardTransitionDuration: Double = Double()
        notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.getValue(&keyboardTransitionDuration)
        
        var keyboardTransitionAnimationCurve: UIViewAnimationCurve = UIViewAnimationCurve(rawValue:0)!
        notification.userInfo![UIKeyboardAnimationCurveUserInfoKey]?.getValue(&keyboardTransitionAnimationCurve)
        
        let keyboardEndFrameView = self.convertRect(keyboardEndFrameWindow, fromView: nil)
        
        let constraintBasedKeyboardDidMoveBlockCalled = (self.constraintBasedKeyboardDidMoveBlock != nil && !CGRectIsNull(keyboardEndFrameView))
        
        if constraintBasedKeyboardDidMoveBlockCalled {
            
            self.constraintBasedKeyboardDidMoveBlock!(keyboardFrameInView: keyboardEndFrameView, opening: false, closing: true)
        }
        
        UIView.animateWithDuration(keyboardTransitionDuration,
                                   delay: 0,
                                   options: [AnimationOptionsForCurve(keyboardTransitionAnimationCurve), .BeginFromCurrentState],
                                   animations: {
                                    
                                    if constraintBasedKeyboardDidMoveBlockCalled {
                                        self.layoutIfNeeded()
                                    }
                                    if self.frameBasedKeyboardDidMoveBlock != nil && !CGRectIsNull(keyboardEndFrameView) {
                                        self.frameBasedKeyboardDidMoveBlock!(keyboardFrameInView: keyboardEndFrameView, opening: false, closing: true)
                                    }
        }) { (finished: Bool) in
            self.removeGestureRecognizer(self.keyboardPanRecognizer!)
            self.keyboardPanRecognizer = nil
            
            if self.keyboardFrameObserved {
                self.keyboardActiveView!.removeObserver(self, forKeyPath: "frame")
                self.keyboardFrameObserved = false
            }
        }
    }
    
    func inputKeyboardDidHide() {
        
        self.keyboardActiveView?.hidden = false
        self.keyboardActiveView?.userInteractionEnabled = true
        self.keyboardActiveView = nil
        self.keyboardActiveInput = nil
        self.keyboardOpened = false
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath! == "frame" && object as? UIView == self.keyboardActiveView {
            
            let keyboardEndFrameWindow = object?.valueForKey(keyPath!)?.CGRectValue()
            let keyboardEndFrameView = self.convertRect(keyboardEndFrameWindow!, fromView: self.keyboardActiveView?.superview)
            
            if CGRectEqualToRect(keyboardEndFrameView, self.previousKeyboardRect) {
                return
            }
            
            if !(self.keyboardActiveView?.hidden)! && !CGRectIsNull(keyboardEndFrameView) {
                
                if self.frameBasedKeyboardDidMoveBlock != nil {
                    self.frameBasedKeyboardDidMoveBlock!(keyboardFrameInView: keyboardEndFrameView, opening: false, closing: false)
                }
                
                if self.constraintBasedKeyboardDidMoveBlock != nil {
                    self.constraintBasedKeyboardDidMoveBlock!(keyboardFrameInView: keyboardEndFrameView, opening: false, closing: true)
                    self.layoutIfNeeded()
                }
            }
            
            self.previousKeyboardRect = keyboardEndFrameView
        }
    }
    
// MARK: - Touches Management
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == self.keyboardPanRecognizer || otherGestureRecognizer == self.keyboardPanRecognizer {
            return true
        }
        else {
            return false
        }
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if gestureRecognizer == self.keyboardPanRecognizer {
            
            return (!(touch.view?.isFirstResponder())! || (self.isKindOfClass(UITextView) && self.isEqual(touch.view)))
        }
        else {
            return true
        }
    }
    
    func panGestureDidChange(gesture: UIPanGestureRecognizer) {
        
        if self.keyboardActiveView == nil || self.keyboardActiveInput == nil || (self.keyboardActiveView?.hidden)! {
            
            self.keyboardActiveInput = self.recursiveFindFirstResponder(self)
            self.keyboardActiveView = self.findInputSetHostView()
            self.keyboardActiveView?.hidden = false
        }
        else {
            
            self.keyboardActiveView?.hidden = false
        }
        
        if self.keyboardActiveView?.superview == nil {
            return
        }
        
        let keyboardViewHeight : CGFloat = self.keyboardActiveView!.bounds.size.height
        let keyboardWindowHeight : CGFloat = self.keyboardActiveView!.superview!.bounds.size.height
        let touchLocationInKeyboardWindow = gesture.locationInView(self.keyboardActiveView?.superview)
        
        if touchLocationInKeyboardWindow.y > keyboardWindowHeight - keyboardViewHeight - self.keyboardTriggerOffset {
            
            self.keyboardActiveView?.userInteractionEnabled = false
        }
        else {
            
            self.keyboardActiveView?.userInteractionEnabled = true
        }
        
        switch gesture.state {
        case .Began:
            
            gesture.maximumNumberOfTouches = gesture.numberOfTouches()
            break
            
        case .Changed:
            var newKeyboardViewFrame = self.keyboardActiveView?.frame
            newKeyboardViewFrame?.origin.y = touchLocationInKeyboardWindow.y + self.keyboardTriggerOffset
            newKeyboardViewFrame?.origin.y = min((newKeyboardViewFrame?.origin.y)!, keyboardWindowHeight)
            newKeyboardViewFrame?.origin.y = max((newKeyboardViewFrame?.origin.y)!, keyboardWindowHeight - keyboardViewHeight)
            
            if newKeyboardViewFrame?.origin.y != self.keyboardActiveView?.frame.origin.y {
                
                UIView.animateWithDuration(0,
                                           delay: 0,
                                           options: [.TransitionNone, .BeginFromCurrentState],
                                           animations: { 
                                            
                                            self.keyboardActiveView?.frame = newKeyboardViewFrame!
                    }, completion: nil)
            }
            
            break
            
        case .Ended, .Cancelled:
            
            let thresholdHeight = keyboardWindowHeight - keyboardViewHeight - self.keyboardTriggerOffset + 44
            let velocity = gesture.velocityInView(self.keyboardActiveView)
            var shouldRecede = Bool()
            
            if touchLocationInKeyboardWindow.y < thresholdHeight || velocity.y < 0 {
                shouldRecede = false
            }
            else {
                shouldRecede = true
            }
            
            var newKeyboardViewFrame = self.keyboardActiveView?.frame
            newKeyboardViewFrame?.origin.y = !shouldRecede ? keyboardWindowHeight - keyboardViewHeight : keyboardWindowHeight
            
            UIView.animateWithDuration(0.25,
                                       delay: 0,
                                       options: [.CurveEaseOut, .BeginFromCurrentState],
                                       animations: { 
                                        self.keyboardActiveView?.frame = newKeyboardViewFrame!
                }, completion: { (finished: Bool) in
                    
                    self.keyboardActiveView?.userInteractionEnabled = !shouldRecede
                    
                    if shouldRecede {
                        self.hideKeyboard()
                    }
            })
            gesture.maximumNumberOfTouches = LONG_MAX
            
            break
        default:
            break
        }
    }
    
// MARK: - Internal Methods
    
    func recursiveFindFirstResponder(view: UIView) -> UIView? {
        
        if view.isFirstResponder() {
            return view
        }
        var found: UIView? = nil
        for v in view.subviews {
            
            found = self.recursiveFindFirstResponder(v)
            if found != nil {
                break
            }
        }
        return found
    }
    
    func findInputSetHostView() -> UIView? {
        
        if #available(iOS 9, *) {
            for window in UIApplication.sharedApplication().windows {
                if window.isKindOfClass(NSClassFromString("UIRemoteKeyboardWindow")!) {
                    for subView in window.subviews {
                        if subView.isKindOfClass(NSClassFromString("UIInputSetHostView")!) {
                            for subSubView in subView.subviews {
                                if subSubView.isKindOfClass(NSClassFromString("UIInputSetHostView")!) {
                                    return subSubView
                                }
                            }
                        }
                    }
                }
            }
        }
        else {
            return (self.keyboardActiveInput!.inputAccessoryView?.superview)!
        }
        
        return nil
    }
    
    func swizzled_addSubview(subView: UIView) {
        
        if subView.inputAccessoryView == nil  {
            
            if subView.isKindOfClass(UITextField) {
                let textField = subView as! UITextField
                if textField.respondsToSelector(Selector("inputAccessoryView")) {
                    let nullView: UIView = UIView(frame: CGRectZero)
                    nullView.backgroundColor = .clearColor()
                    textField.inputAccessoryView = nullView
                }
            }
            else if subView.isKindOfClass(UITextView) {
                let textView = subView as! UITextView
                if textView.respondsToSelector(Selector("inputAccessoryView")) {
                    let nullView: UIView = UIView(frame: CGRectZero)
                    nullView.backgroundColor = .clearColor()
                    textView.inputAccessoryView = nullView
                }
            }
        }
        self.swizzled_addSubview(subView)
    }
}