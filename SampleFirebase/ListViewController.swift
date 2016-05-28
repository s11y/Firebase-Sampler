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
    var contentArray: [NSDictionary] = []
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
        
        fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData()  {
        ref.child((FIRAuth.auth()?.currentUser?.uid)!).observeEventType(.Value, withBlock: {(snapShots) in
            if snapShots.exists() == true {
                print(snapShots)
                for i in 0 ..< snapShots.hash {
                    let item = snapShots as! FIRDataSnapshot
                    let dic = item.value as! NSDictionary
                    self.contentArray.append(dic)
                }
                
                print(self.contentArray)
                self.table.reloadData()
            }
        })
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCellWithIdentifier("ListCell") as! ListTableViewCell
        
        let item = contentArray[indexPath.row]
        print(item["content"])
        
        
        return cell
    }
    
}
