//
//  ListViewController.swift
//  SampleFirebase
//
//  Created by ShinokiRyosei on 2016/02/27.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    var contentArray: [FIRDataSnapshot] = []
    var itemArray: [Data] = []
    let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.registerNib(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        
        table.delegate = self
        table.dataSource = self
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        read()
        
        table.estimatedRowHeight = 56
        table.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        ref.removeAllObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func read()  {
        if contentArray.count >= 0 {
            contentArray.removeAll()
        }
        ref.child((FIRAuth.auth()?.currentUser?.uid)!).observeEventType(.ChildAdded, withBlock: {(snapShots) in
            if snapShots.exists() == true {
                self.contentArray.append(snapShots)
                self.table.reloadData()
            }
        })
        print(contentArray)
    }
    
    func delete(deleteIndexPath indexPath: NSIndexPath) {
        ref.child((FIRAuth.auth()?.currentUser?.uid)!).child(contentArray[indexPath.row].key).removeValue()
        contentArray.removeAtIndex(indexPath.row)
    }
    
    func getDate(number: NSTimeInterval) -> String {
        let date = NSDate(timeIntervalSince1970: number)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.stringFromDate(date)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.delete(deleteIndexPath: indexPath)
            table.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCellWithIdentifier("ListCell") as! ListTableViewCell
        
        let item = contentArray[indexPath.row]
        let content = item.value as! Dictionary<String, AnyObject>
        cell.contentLabel.text = String(content["content"]!)
        let time = content["date"] as! NSTimeInterval
        cell.postDateLabel.text = self.getDate(time/1000)
        
        return cell
    }
    
}
