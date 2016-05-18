//
//  ListViewController.swift
//  SampleFirebase
//
//  Created by ShinokiRyosei on 2016/02/27.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    var contentArray: [Data] = []
    var fireBase = Firebase(url: "https://samplecrud.firebaseio.com")
    var items = [FDataSnapshot]()
    
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
        fireBase.observeSingleEventOfType(.Value, withBlock: { (snapShot) in
            print(snapShot)
            
            
            for item in snapShot.children {
                self.items.append(item as! FDataSnapshot)
            }

            }) { (error) in
                print("\(error.localizedDescription)")
        }
        table.reloadData()
    }
    
    
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCellWithIdentifier("ListCell") as! ListTableViewCell

        var item = items[indexPath.row]
        cell.contentLabel.text = item.children.
        
        
        return cell
    }

}
