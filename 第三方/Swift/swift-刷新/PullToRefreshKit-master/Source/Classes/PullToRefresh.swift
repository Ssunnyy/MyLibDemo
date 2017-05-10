//
//  PullToRefreshKit.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/11.
//  I refer a lot logic for MJRefresh https://github.com/CoderMJLee/MJRefresh ,thanks to this lib and all contributors.
//  Copyright © 2016年 Leo. All rights reserved.

import Foundation
import UIKit

public enum RefreshResult{
    /**
     *  刷新成功
     */
    case Success
    /**
     *  刷新失败
     */
    case Failure
    /**
     *  刷新出错
     */
    case Error
    /**
     *  默认状态
     */
    case None
}
public protocol RefreshAble:class{
    /**
     触发动作的距离，对于header/footer来讲，就是视图的高度；对于left/right来讲，就是视图的宽度
    */
    func distanceToRefresh()->CGFloat
}
public protocol RefreshableHeader:RefreshAble{
    /**
      不在刷新状态的时候，百分比回调，在这里你根据百分比来动态的调整你的刷新视图
     - parameter percent: 拖拽的百分比，比如一共距离是100，那么拖拽10的时候，percent就是0.1
     */
    func percentUpdateWhenNotRefreshing(percent:CGFloat)
    
    /**
     松手就会刷新的回调,在这个回调里，将视图切换到动画的状态
     */
    func releaseWithRefreshingState()
    
    /**
       刷新结束，将要进行隐藏的动画，一般在这里告诉用户刷新的结果
     - parameter result: 刷新结果
     */
    func didBeginEndRefershingAnimation(result:RefreshResult)
    /**
       刷新结束，隐藏的动画结束，一般在这里把视图隐藏，各个参数恢复到最初状态
     
     - parameter result: 刷新结果
     */
    func didCompleteEndRefershingAnimation(result:RefreshResult)
    
}

public protocol RefreshableFooter:RefreshAble{
    /**
     不需要下拉加载更多的回调
     */
    func didUpdateToNoMoreData()
    /**
     重新设置到常态的回调
     */
    func didResetToDefault()
    /**
     结束刷新的回调
     */
    func didEndRefreshing()
    /**
     已经开始执行刷新逻辑，在一次刷新中，只会调用一次
     */
    func didBeginRefreshing()
    
    /**
     当Scroll触发刷新，这个方法返回是否需要刷新
     */
    func shouldBeginRefreshingWhenScroll()->Bool
}

public protocol RefreshableLeftRight:RefreshAble{
    /**
     已经开始执行刷新逻辑，在一次刷新中，只会调用一次
     */
    func didBeginRefreshing()

    /**
     结束刷新的回调
     */
    func didCompleteEndRefershingAnimation()
    /**
     拖动百分比变化的回调
     
     - parameter percent: 拖动百分比，大于0
     */
    func percentUpdateWhenNotRefreshing(percent:CGFloat)
}


public protocol SetUp {}
public extension SetUp where Self: AnyObject {
    //Add @noescape to make sure that closure is sync and can not be stored
    public func SetUp(@noescape closure: Self -> Void) -> Self {
        closure(self)
        return self
    }
}
extension NSObject: SetUp {}

//Header
public extension UIScrollView{
    public func setUpHeaderRefresh(action:()->())->DefaultRefreshHeader{
        let header = DefaultRefreshHeader(frame:CGRectMake(0,0,CGRectGetWidth(self.frame),PullToRefreshKitConst.defaultHeaderHeight))
        return setUpHeaderRefresh(header, action: action)
    }
    
   public  func setUpHeaderRefresh<T:UIView where T:RefreshableHeader>(header:T,action:()->())->T{
        let oldContain = self.viewWithTag(PullToRefreshKitConst.headerTag)
        oldContain?.removeFromSuperview()
        let height = header.distanceToRefresh()
        let frame = CGRectMake(0,-1 * height,CGRectGetWidth(self.frame),height)
        let containComponent = RefreshHeaderContainer(frame: frame)
        containComponent.tag = PullToRefreshKitConst.headerTag
        containComponent.refreshAction = action
        self.addSubview(containComponent)
        
        containComponent.delegate = header
        header.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        header.frame = containComponent.bounds
        containComponent.addSubview(header)
        return header
    }
   public func beginHeaderRefreshing(){
        let header = self.viewWithTag(PullToRefreshKitConst.headerTag) as? RefreshHeaderContainer
        header?.beginRefreshing()
        
    }
   public  func endHeaderRefreshing(result:RefreshResult = .None){
        let header = self.viewWithTag(PullToRefreshKitConst.headerTag) as? RefreshHeaderContainer
        header?.endRefreshing(result)
    }
}

//Footer
public extension UIScrollView{
   public func setUpFooterRefresh(action:()->())->DefaultRefreshFooter{
        let footer = DefaultRefreshFooter(frame: CGRectMake(0,0,CGRectGetWidth(self.frame),PullToRefreshKitConst.defaultFooterHeight))
        return setUpFooterRefresh(footer, action: action)
    }
   public func setUpFooterRefresh<T:UIView where T:RefreshableFooter>(footer:T,action:()->())->T{
        let oldContain = self.viewWithTag(PullToRefreshKitConst.footerTag)
        oldContain?.removeFromSuperview()
        let frame = CGRectMake(0,0,CGRectGetWidth(self.frame), PullToRefreshKitConst.defaultFooterHeight)
        
        let containComponent = RefreshFooterContainer(frame: frame)
        containComponent.tag = PullToRefreshKitConst.footerTag
        containComponent.refreshAction = action
        self.insertSubview(containComponent, atIndex: 0)
        
        containComponent.delegate = footer
        footer.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        footer.frame = containComponent.bounds
        containComponent.addSubview(footer)
        return footer
    }
   public func beginFooterRefreshing(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        footer?.beginRefreshing()
    }
   public func endFooterRefreshing(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        footer?.endRefreshing()
    }
   public func setFooterNoMoreData(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        footer?.endRefreshing()
    }
   public func resetFooterToDefault(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        footer?.resetToDefault()
    }
   public  func endFooterRefreshingWithNoMoreData(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        footer?.endRefreshing()
        footer?.updateToNoMoreData()
    }
}

//Left
extension UIScrollView{
   public func setUpLeftRefresh(action:()->())->DefaultRefreshLeft{
        let left = DefaultRefreshLeft(frame: CGRectMake(0,0,PullToRefreshKitConst.defaultLeftWidth, CGRectGetHeight(self.frame)))
        return setUpLeftRefresh(left, action: action)
    }
   public func setUpLeftRefresh<T:UIView where T:RefreshableLeftRight>(left:T,action:()->())->T{
        let oldContain = self.viewWithTag(PullToRefreshKitConst.leftTag)
        oldContain?.removeFromSuperview()
        let frame = CGRectMake(-1.0 * PullToRefreshKitConst.defaultLeftWidth,0,PullToRefreshKitConst.defaultLeftWidth, CGRectGetHeight(self.frame))
        let containComponent = RefreshLeftContainer(frame: frame)
        containComponent.tag = PullToRefreshKitConst.leftTag
        containComponent.refreshAction = action
        self.insertSubview(containComponent, atIndex: 0)
        
        containComponent.delegate = left
        left.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        left.frame = containComponent.bounds
        containComponent.addSubview(left)
        return left
    }
}
//Right
extension UIScrollView{
   public  func setUpRightRefresh(action:()->())->DefaultRefreshRight{
        let right = DefaultRefreshRight(frame: CGRectMake(0 ,0 ,PullToRefreshKitConst.defaultLeftWidth ,CGRectGetHeight(self.frame) ))
        return setUpRightRefresh(right, action: action)
    }
   public func setUpRightRefresh<T:UIView where T:RefreshableLeftRight>(right:T,action:()->())->T{
        let oldContain = self.viewWithTag(PullToRefreshKitConst.rightTag)
        oldContain?.removeFromSuperview()
        let frame = CGRectMake(0 ,0 ,PullToRefreshKitConst.defaultLeftWidth ,CGRectGetHeight(self.frame) )
        let containComponent = RefreshRightContainer(frame: frame)
        containComponent.tag = PullToRefreshKitConst.rightTag
        containComponent.refreshAction = action
        self.insertSubview(containComponent, atIndex: 0)
        
        containComponent.delegate = right
        right.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        right.frame = containComponent.bounds
        containComponent.addSubview(right)
        return right
    }
}
