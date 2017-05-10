//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

// SO: http://stackoverflow.com/questions/1214965/setting-action-for-back-button-in-navigation-controller/19132881#comment34452906_19132881
public protocol BackBarButtonItemDelegate {
    func viewControllerShouldPopOnBackBarButtonItem() -> Bool
}

extension UINavigationController {
    public func navigationBar(navigationBar: UINavigationBar, shouldPopItem item: UINavigationItem) -> Bool {
        if viewControllers.count < navigationBar.items?.count {
            return true
        }
        var shouldPop = true
        if let viewController = topViewController as? BackBarButtonItemDelegate {
            shouldPop = viewController.viewControllerShouldPopOnBackBarButtonItem()
        }
        if shouldPop {
            dispatch_async(dispatch_get_main_queue()) {
                self.popViewControllerAnimated(true)
            }
        } else {
            // Prevent the back button from staying in an disabled state
            for view in navigationBar.subviews {
                if view.alpha < 1.0 {
                    UIView.animateWithDuration(0.25, animations: { () in
                        view.alpha = 1.0
                    })
                }
            }
        }
        return false
    }
}

var NAV_BAR_KEY = "NavigationBarcoverView" //!!!: 这种占用了全局常用关键字很容易出错

extension UINavigationBar {
    
    func hideBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView?.hidden = true
    }
    
    func showBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView?.hidden = false
    }
    
    private func hairlineImageViewInNavigationBar(view: UIView) -> UIImageView? {
        if view.isKindOfClass(UIImageView) && view.bounds.height <= 1.0 {
            return (view as? UIImageView)
        }
        
        let subviews = (view.subviews as [UIView])
        for subview: UIView in subviews {
            if let imageView = hairlineImageViewInNavigationBar(subview) {
                return imageView
            }
        }
        
        return nil
    }
    
    /// 定义的一个计算属性，如果可以我更希望直接顶一个存储属性。它用来返回和设置我们需要加到
    /// UINavigationBar上的View
    var coverView: UIView? {
        get {
            //这句的意思大概可以理解为利用key在self中取出对应的对象,如果没有key对应的对象就返回niu
            return objc_getAssociatedObject(self, &NAV_BAR_KEY) as? UIView
        }
        
        set {
            //与上面对应是重新设置这个对象，最后一个参数如果学过oc的话很好理解，就是代表这个newValue的属性
            //OBJC_ASSOCIATION_RETAIN_NONATOMIC意味着:strong,nonatomic
            objc_setAssociatedObject(self, &NAV_BAR_KEY, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //在透明导航栏需要渐变时使用
    func setMyBackgroundColor(color: UIColor, alpha: CGFloat = 0) {
        if let coverView = self.coverView {
            coverView.backgroundColor = color
        } else {
            setBackgroundImage(UIImage(), forBarMetrics: .Default)
            shadowImage = UIImage()
            
            let view = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.mainScreen().bounds.size.width, height: bounds.height + 20))
            view.userInteractionEnabled = false
            view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            insertSubview(view, atIndex: 0)
            
            view.backgroundColor = color
            coverView = view
        }
        titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(alpha)]
    }
    
    func setMyBackgroundColorAlpha(alpha: CGFloat) {
        if let coverView = self.coverView {
            coverView.backgroundColor = coverView.backgroundColor?.colorWithAlphaComponent(alpha)
        }
    }
}

extension CALayer {
    func shake() {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        let s = 16
        keyFrameAnimation.values = [0, -s, 0, s, 0, -s, 0, s, 0]
        keyFrameAnimation.duration = 0.1
        keyFrameAnimation.repeatCount = 2
        addAnimation(keyFrameAnimation, forKey: "shake")
    }
}
