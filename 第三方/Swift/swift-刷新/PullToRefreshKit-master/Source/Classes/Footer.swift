//
//  Footer.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/11.
//  I refer a lot logic for MJRefresh https://github.com/CoderMJLee/MJRefresh ,thanks to this lib and all contributors.
//  Copyright © 2016年 Leo. All rights reserved.

import Foundation
import UIKit

public enum RefreshKitFooterText{
    case pullToRefresh
    case refreshing
    case noMoreData
    case tapToRefresh
}

public class DefaultRefreshFooter:UIView,RefreshableFooter{
    public let spinner:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    public  let textLabel:UILabel = UILabel(frame: CGRectMake(0,0,120,40)).SetUp {
        $0.font = UIFont.systemFontOfSize(14)
        $0.textAlignment = .Center
    }
    public var needTapToLoadMore = false{
        didSet{
            tap.enabled = needTapToLoadMore
            if needTapToLoadMore{
                textLabel.text = textDic[.tapToRefresh]
            }else{
                textLabel.text = textDic[.pullToRefresh]
            }
        }
    }
    private var tap:UITapGestureRecognizer!
    private var textDic = [RefreshKitFooterText:String]()
    /**
     This function can only be called before refreshing
     */
    public  func setText(text:String,mode:RefreshKitFooterText){
        textDic[mode] = text
        textLabel.text = textDic[.pullToRefresh]
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(spinner)
        addSubview(textLabel)
        textLabel.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        spinner.center = CGPointMake(frame.width/2 - 60 - 20, frame.size.height/2)
        textDic[.pullToRefresh] = PullToRefreshKitFooterString.pullToRefresh
        textDic[.refreshing] = PullToRefreshKitFooterString.refreshing
        textDic[.noMoreData] = PullToRefreshKitFooterString.noMoreData
        textDic[.tapToRefresh] = PullToRefreshKitFooterString.tapToRefresh
        textLabel.text = textDic[.pullToRefresh]
        tap = UITapGestureRecognizer(target: self, action: #selector(DefaultRefreshFooter.catchTap(_:)))
        tap.enabled = needTapToLoadMore
        self.addGestureRecognizer(tap)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func catchTap(tap:UITapGestureRecognizer){
        let scrollView = self.superview?.superview as? UIScrollView
        scrollView?.beginFooterRefreshing()
    }
    // MARK: - Refreshable  -
    public func distanceToRefresh() -> CGFloat {
        return PullToRefreshKitConst.defaultFooterHeight
    }
    public func didBeginRefreshing() {
        textLabel.text = textDic[.refreshing];
        spinner.startAnimating()
    }
    public func didEndRefreshing() {
        if needTapToLoadMore{
            textLabel.text = textDic[.tapToRefresh]
        }else{
            textLabel.text = textDic[.pullToRefresh]
        }
        spinner.stopAnimating()
    }
    public func didUpdateToNoMoreData(){
        textLabel.text = textDic[.noMoreData]
    }
    public func didResetToDefault() {
        if needTapToLoadMore{
            textLabel.text = textDic[.tapToRefresh]
        }else{
            textLabel.text = textDic[.pullToRefresh]
        }
    }
    public func shouldBeginRefreshingWhenScroll()->Bool {
        return !needTapToLoadMore
    }
// MARK: - Handle touch -
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        guard needTapToLoadMore else{
            return
        }
        self.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
    }
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        guard needTapToLoadMore else{
            return
        }
        self.backgroundColor = UIColor.whiteColor()
    }
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        guard needTapToLoadMore else{
            return
        }
        self.backgroundColor = UIColor.whiteColor()
    }
}
class RefreshFooterContainer:UIView{
// MARK: - Propertys -
    enum RefreshFooterState {
        case Idle
        case Refreshing
        case WillRefresh
        case NoMoreData
    }
    var refreshAction:(()->())?
    var attachedScrollView:UIScrollView!
    weak var delegate:RefreshableFooter?
    private var _state:RefreshFooterState = .Idle
    var state:RefreshFooterState{
        get{
            return _state
        }
        set{
            guard newValue != _state else{
                return
            }
            _state =  newValue
            if newValue == .Refreshing{
                dispatch_async(dispatch_get_main_queue(), {
                    self.delegate?.didBeginRefreshing()
                    self.refreshAction?()
                })
            }else if newValue == .NoMoreData{
                self.delegate?.didUpdateToNoMoreData()
            }else if newValue == .Idle{
                self.delegate?.didResetToDefault()
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
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: - Life circle -
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if self.state == .WillRefresh {
            self.state = .Refreshing
        }
    }
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        guard newSuperview != nil else{ //remove from superview
            if !self.hidden{
                var inset = attachedScrollView.contentInset
                inset.bottom = inset.bottom - CGRectGetHeight(self.frame)
                attachedScrollView.contentInset = inset
            }
            return
        }
        guard newSuperview is UIScrollView else{
            return;
        }
        attachedScrollView = newSuperview as? UIScrollView
        attachedScrollView.alwaysBounceVertical = true
        if !self.hidden {
            var contentInset = attachedScrollView.contentInset
            contentInset.bottom = contentInset.bottom + CGRectGetHeight(self.frame)
            attachedScrollView.contentInset = contentInset
        }
        self.frame = CGRectMake(0,attachedScrollView.contentSize.height,CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
        addObservers()
    }
    deinit{
        removeObservers()
    }
    
// MARK: - Private -
    private func addObservers(){
        attachedScrollView?.addObserver(self, forKeyPath:PullToRefreshKitConst.KPathOffSet, options: [.Old,.New], context: nil)
        attachedScrollView?.addObserver(self, forKeyPath:PullToRefreshKitConst.KPathContentSize, options:[.Old,.New] , context: nil)
        attachedScrollView?.panGestureRecognizer.addObserver(self, forKeyPath:PullToRefreshKitConst.KPathPanState, options:[.Old,.New] , context: nil)
    }
    private func removeObservers(){
        attachedScrollView?.removeObserver(self, forKeyPath: PullToRefreshKitConst.KPathContentSize,context: nil)
        attachedScrollView?.removeObserver(self, forKeyPath: PullToRefreshKitConst.KPathOffSet,context: nil)
        attachedScrollView?.panGestureRecognizer.removeObserver(self, forKeyPath: PullToRefreshKitConst.KPathPanState,context: nil)
    }
    func handleScrollOffSetChange(change: [String : AnyObject]?){
        if state != .Idle && self.frame.origin.y != 0{
            return
        }
        let insetTop = attachedScrollView.contentInset.top
        let contentHeight = attachedScrollView.contentSize.height
        let scrollViewHeight = attachedScrollView.frame.size.height
        if insetTop + contentHeight > scrollViewHeight{
            let offSetY = attachedScrollView.contentOffset.y
            if offSetY > self.frame.origin.y - scrollViewHeight + attachedScrollView.contentInset.bottom{
                let oldOffset = change?[NSKeyValueChangeOldKey]?.CGPointValue()
                let newOffset = change?[NSKeyValueChangeNewKey]?.CGPointValue()
                guard newOffset?.y > oldOffset?.y else{
                    return
                }
                let shouldStart = self.delegate?.shouldBeginRefreshingWhenScroll()
                guard shouldStart! else{
                    return
                }
                beginRefreshing()
            }
        }
    }
    func handlePanStateChange(change: [String : AnyObject]?){
        guard state == .Idle else{
            return
        }
        if attachedScrollView.panGestureRecognizer.state == .Ended {
            let scrollInset = attachedScrollView.contentInset
            let scrollOffset = attachedScrollView.contentOffset
            let contentSize = attachedScrollView.contentSize
            if scrollInset.top + contentSize.height <= CGRectGetHeight(attachedScrollView.frame){
                if scrollOffset.y >= -1 * scrollInset.top {
                    let shouldStart = self.delegate?.shouldBeginRefreshingWhenScroll()
                    guard shouldStart! else{
                        return
                    }
                    beginRefreshing()
                }
            }else{
                if scrollOffset.y > contentSize.height + scrollInset.bottom - CGRectGetHeight(attachedScrollView.frame) {
                    let shouldStart = self.delegate?.shouldBeginRefreshingWhenScroll()
                    guard shouldStart! else{
                        return
                    }
                    beginRefreshing()
                }
            }
        }
    }
    func handleContentSizeChange(change: [String : AnyObject]?){
        self.frame = CGRectMake(0,self.attachedScrollView.contentSize.height,self.frame.size.width,self.frame.size.height)
    }
// MARK: - KVO -
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard self.userInteractionEnabled else{
            return;
        }
        if keyPath == PullToRefreshKitConst.KPathOffSet {
            handleScrollOffSetChange(change)
        }
        guard !self.hidden else{
            return;
        }
        if keyPath == PullToRefreshKitConst.KPathPanState{
            handlePanStateChange(change)
        }
        if keyPath == PullToRefreshKitConst.KPathContentSize {
            handleContentSizeChange(change)
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
    func endRefreshing(){
        self.state = .Idle
        self.delegate?.didEndRefreshing()
    }
    func resetToDefault(){
        self.state = .Idle
    }
    func updateToNoMoreData(){
        self.state = .NoMoreData
    }
}

