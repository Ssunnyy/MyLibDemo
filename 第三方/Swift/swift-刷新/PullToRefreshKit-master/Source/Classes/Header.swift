//
//  PullToRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/11.
//  I refer a lot logic for MJRefresh https://github.com/CoderMJLee/MJRefresh ,thanks to this lib and all contributors.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit


public enum RefreshKitHeaderText{
    case pullToRefresh
    case releaseToRefresh
    case refreshSuccess
    case refreshError
    case refreshFailure
    case refreshing
}

public class DefaultRefreshHeader:UIView,RefreshableHeader{
    public let spinner:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    public let textLabel:UILabel = UILabel(frame: CGRectMake(0,0,120,40))
    public let imageView:UIImageView = UIImageView(frame: CGRectZero)
    private var textDic = [RefreshKitHeaderText:String]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(spinner)
        addSubview(textLabel)
        addSubview(imageView);
        let image = UIImage(named: "arrow_down", inBundle: NSBundle(forClass: DefaultRefreshHeader.self), compatibleWithTraitCollection: nil)
        imageView.image = image
        imageView.sizeToFit()
        imageView.frame = CGRectMake(0, 0, 24, 24)
        imageView.center = CGPointMake(frame.width/2 - 60 - 20, frame.size.height/2)
        spinner.center = imageView.center
        
        textLabel.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        textLabel.font = UIFont.systemFontOfSize(14)
        textLabel.textAlignment = .Center
        self.hidden = true
        //Default text
        textDic[.pullToRefresh] = PullToRefreshKitHeaderString.pullToRefresh
        textDic[.releaseToRefresh] = PullToRefreshKitHeaderString.releaseToRefresh
        textDic[.refreshSuccess] = PullToRefreshKitHeaderString.refreshSuccess
        textDic[.refreshError] = PullToRefreshKitHeaderString.refreshError
        textDic[.refreshFailure] = PullToRefreshKitHeaderString.refreshFailure
        textDic[.refreshing] = PullToRefreshKitHeaderString.refreshing
        textLabel.text = textDic[.pullToRefresh]
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setText(text:String,mode:RefreshKitHeaderText){
        textDic[mode] = text
    }
    // MARK: - Refreshable  -
    public func distanceToRefresh() -> CGFloat {
        return PullToRefreshKitConst.defaultHeaderHeight
    }
    public func percentUpdateWhenNotRefreshing(percent:CGFloat){
        
        self.hidden = !(percent > 0.0)
        if percent > 1.0{
            textLabel.text = textDic[.releaseToRefresh]
            guard CGAffineTransformEqualToTransform(self.imageView.transform, CGAffineTransformIdentity)  else{
                return
            }
            UIView.animateWithDuration(0.4, animations: {
                self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI+0.000001))
            })
        }
        if percent <= 1.0{
            textLabel.text = textDic[.pullToRefresh]
            guard CGAffineTransformEqualToTransform(self.imageView.transform, CGAffineTransformMakeRotation(CGFloat(-M_PI+0.000001)))  else{
                return
            }
            UIView.animateWithDuration(0.4, animations: {
                self.imageView.transform = CGAffineTransformIdentity
            })
        }
    }
    
    public func percentageChangedDuringReleaseing(percent:CGFloat){
    
    }
    public func didBeginEndRefershingAnimation(result:RefreshResult) {
        spinner.stopAnimating()
        imageView.transform = CGAffineTransformIdentity
        imageView.hidden = false
        switch result {
        case .Success:
            textLabel.text = textDic[.refreshSuccess]
        case .Error:
            textLabel.text = textDic[.refreshError]
        case .Failure:
            textLabel.text = textDic[.refreshFailure]
        case .None:
            textLabel.text = textDic[.pullToRefresh]
        }
    }
    public func didCompleteEndRefershingAnimation(result:RefreshResult) {
        textLabel.text = textDic[.pullToRefresh]
        self.hidden = true
    }
    public func releaseWithRefreshingState() {
        self.hidden = false
        textLabel.text = textDic[.refreshing]
        spinner.startAnimating()
        imageView.hidden = true
    }
}

public class RefreshHeaderContainer:UIView{
    // MARK: - Propertys -
    enum RefreshHeaderState {
        case Idle
        case Pulling
        case Refreshing
        case WillRefresh
    }
    var refreshAction:(()->())?
    var attachedScrollView:UIScrollView!
    var originalInset:UIEdgeInsets?
    weak var delegate:RefreshableHeader?
    private var currentResult:RefreshResult = .None
    private var _state:RefreshHeaderState = .Idle
    private var insetTDelta:CGFloat = 0.0
    private var state:RefreshHeaderState{
        get{
            return _state
        }
        set{
            guard newValue != _state else{
                return
            }
            let oldValue = _state
            _state =  newValue
            switch newValue {
            case .Idle:
                guard oldValue == .Refreshing else{
                    return
                }
                UIView.animateWithDuration(0.4, animations: {
                    var oldInset = self.attachedScrollView.contentInset
                    oldInset.top = oldInset.top + self.insetTDelta
                    self.attachedScrollView.contentInset = oldInset
                    
                    }, completion: { (finished) in
                        self.delegate?.didCompleteEndRefershingAnimation(self.currentResult)
                })
            case .Refreshing:
                dispatch_async(dispatch_get_main_queue(), {
                    UIView.animateWithDuration(0.4, animations: {
                        let top = (self.originalInset?.top)! + CGRectGetHeight(self.frame)
                        var oldInset = self.attachedScrollView.contentInset
                        oldInset.top = top
                        self.attachedScrollView.contentInset = oldInset
                        self.attachedScrollView.contentOffset = CGPointMake(0, -1.0 * top)
                        }, completion: { (finsihed) in
                            self.refreshAction?()
                    })
                    self.delegate?.percentUpdateWhenNotRefreshing(1.0)
                    self.delegate?.releaseWithRefreshingState()
                })
            default:
                break
            }
        }
    }
    // MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    func commonInit(){
        self.userInteractionEnabled = true
        self.backgroundColor = UIColor.clearColor()
        self.autoresizingMask = .FlexibleWidth
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life circle -
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if self.state == .WillRefresh {
            self.state = .Refreshing
        }
    }
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        guard newSuperview is UIScrollView else{
            return;
        }
        attachedScrollView = newSuperview as? UIScrollView
        attachedScrollView.alwaysBounceVertical = true
        originalInset = attachedScrollView?.contentInset
        addObservers()
    }
    deinit{
        removeObservers()
    }
    // MARK: - Private -
    private func addObservers(){
        attachedScrollView?.addObserver(self, forKeyPath:PullToRefreshKitConst.KPathOffSet, options: [.Old,.New], context: nil)
    }
    private func removeObservers(){
        attachedScrollView?.removeObserver(self, forKeyPath: PullToRefreshKitConst.KPathOffSet,context: nil)
    }
    func handleScrollOffSetChange(change: [String : AnyObject]?){
        if state == .Refreshing {
//Refer from here https://github.com/CoderMJLee/MJRefresh/blob/master/MJRefresh/Base/MJRefreshHeader.m, thanks to this lib again
            guard self.window != nil else{
                return
            }
            let offset = attachedScrollView.contentOffset
            let inset = originalInset!
            var insetT = -1 * offset.y > inset.top ? (-1 * offset.y):inset.top
            insetT = insetT > CGRectGetHeight(self.frame) + inset.top ? CGRectGetHeight(self.frame) + inset.top:insetT
            var oldInset = attachedScrollView.contentInset
            oldInset.top = insetT
            attachedScrollView.contentInset = oldInset
            insetTDelta = inset.top - insetT
            return;
        }
        originalInset =  attachedScrollView.contentInset
        let offSetY = attachedScrollView.contentOffset.y
        let topShowOffsetY = -1.0 * originalInset!.top
        guard offSetY <= topShowOffsetY else{
            return
        }
        let normal2pullingOffsetY = topShowOffsetY - self.frame.size.height
        if attachedScrollView.dragging {
            if state == .Idle && offSetY < normal2pullingOffsetY {
                self.state = .Pulling
            }else if state == .Pulling && offSetY >= normal2pullingOffsetY{
                state = .Idle
            }
        }else if state == .Pulling{
            beginRefreshing()
            return
        }
        let percent = (topShowOffsetY - offSetY)/self.frame.size.height
        //防止在结束刷新的时候，percent的跳跃
        if let oldOffset = change?[NSKeyValueChangeOldKey]?.CGPointValue(){
            let oldPercent = (topShowOffsetY - oldOffset.y)/self.frame.size.height
            if oldPercent >= 1.0 && percent == 0.0{
                return
            }else{
                self.delegate?.percentUpdateWhenNotRefreshing(percent)
            }
        }else{
            self.delegate?.percentUpdateWhenNotRefreshing(percent)
        }
    }
    // MARK: - KVO -
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard self.userInteractionEnabled else{
            return;
        }
        if keyPath == PullToRefreshKitConst.KPathOffSet {
            handleScrollOffSetChange(change)
        }
    }
    // MARK: - API -
    func beginRefreshing(){
        if self.window != nil {
            self.state = .Refreshing
        }else{
            if state != .Refreshing{
                self.state = .WillRefresh
            }
        }
    }
    func endRefreshing(result:RefreshResult){
        self.delegate?.didBeginEndRefershingAnimation(result)
        self.state = .Idle
    }
}



