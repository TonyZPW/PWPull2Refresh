//
//  ViewController.swift
//  PWPull2Refresh
//
//  Created by Tony_Zhao on 4/19/15.
//  Copyright (c) 2015 TonyZPW. All rights reserved.
//

import UIKit

func delayBySeconds(seconds: Double, delayedCode: ()->()){
    let targetTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * seconds))
    dispatch_after(targetTime, dispatch_get_main_queue()) { () -> Void in
        delayedCode()
    }
}

class ViewController: UIViewController {

    var refreshView: PWRefreshView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        
        self.refreshView = PWRefreshView(frame: CGRectMake(0, -128, CGRectGetWidth(view.frame), 128), scrollView: tableView)
        self.refreshView.delegate = self
        self.tableView.addSubview(self.refreshView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: PWRefreshViewDelegate{
    func refreshViewDidRefresh(refreshView: PWRefreshView) {
        delayBySeconds(3, { () -> () in
            refreshView.endRefreshing()
        })
    }
}

extension ViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.refreshView.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel.text = "asdasdasdasdasd"
        return cell
    }
}

