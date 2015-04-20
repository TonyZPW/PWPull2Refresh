//
//  PWRefreshView.swift
//  PWPull2Refresh
//
//  Created by Tony_Zhao on 4/19/15.
//  Copyright (c) 2015 TonyZPW. All rights reserved.
//

import UIKit


protocol PWRefreshViewDelegate: class{
    func refreshViewDidRefresh(refreshView: PWRefreshView)
}

class PWRefreshView: UIView {
    
    private unowned var scrollView: UIScrollView
    
    var progressPercentage: CGFloat = 0
    
    var isRefreshing = false
    
    var path: UIBezierPath?
    
    var offset: CGFloat = 0
    
    weak var delegate:PWRefreshViewDelegate?
    init(frame: CGRect, scrollView: UIScrollView) {
        self.scrollView = scrollView;
        super.init(frame: frame)
        self.backgroundColor = UIColor.greenColor()
         clipsToBounds = true
        //draw the circle
        path = UIBezierPath(arcCenter: CGPointMake(frame.size.width/2 - 15, frame.size.height/2 - 15), radius: CGFloat(15), startAngle: -CGFloat(M_PI), endAngle:0, clockwise: true)

        updateBackgroundColor()
    }

    required init(coder aDecoder: NSCoder) {
        self.scrollView = UIScrollView()
        super.init(coder: aDecoder)
    }
    
    func updateBackgroundColor() {
        let value = progressPercentage * 0.7 + 0.2
        backgroundColor = UIColor(red: value, green: value, blue: value, alpha: 1.0)
        
    }
    
    func beginRefreshing(){
        isRefreshing = true
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.scrollView.contentInset.top += 128
        }) { (_) -> Void in
            
        }
    }
    
    func endRefreshing(){
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.scrollView.contentInset.top -= 128
            }) { (_) -> Void in
                self.isRefreshing = false
        }
    }
}

extension PWRefreshView: UIScrollViewDelegate{
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
      
        
        var visibleHeight = max(0,-(scrollView.contentInset.top + scrollView.contentOffset.y))
        if(isRefreshing){
            return
        }
        progressPercentage = min(1,visibleHeight / 128)
        
        updateBackgroundColor()
    }
    
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(!isRefreshing && progressPercentage == 1){
            beginRefreshing()
            let top = -(scrollView.contentInset.top)
            targetContentOffset.memory.y = top
            delegate?.refreshViewDidRefresh(self)
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        
         path!.removeAllPoints()
         path = UIBezierPath(arcCenter: CGPointMake(frame.size.width/2 - 15, frame.size.height/2 - 15), radius: CGFloat(15), startAngle: -CGFloat(M_PI), endAngle:CGFloat(M_PI * 2), clockwise: true)
        if(!isRefreshing){
            path!.addLineToPoint(CGPointMake(frame.size.width/2 - 15, frame.size.height / 2 - 15 + progressPercentage * 64))
        }
        UIColor.redColor().set()
         path!.fill()

    }
}
