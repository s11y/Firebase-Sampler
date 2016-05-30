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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func read()  {
        ref.child((FIRAuth.auth()?.currentUser?.uid)!).observeEventType(.ChildAdded, withBlock: {(snapShots) in
            if snapShots.exists() == true {
                self.contentArray.append(snapShots)
                self.table.reloadData()
            }
        })
        
    }
    
    func getDate(time: NSTimeInterval) -> String {
        let date = NSDate(timeIntervalSince1970: time)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.stringFromDate(date)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCellWithIdentifier("ListCell") as! ListTableViewCell
        
        let item = contentArray[indexPath.row]
        let content = item.value as! Dictionary<String, AnyObject>
        cell.contentLabel.text = "\(content["content"])"
        let time = content["date"]
        cell.postDateLabel.text = "\(content["date"])"
        return cell
    }
    
}
