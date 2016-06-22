//
//  ListViewController.swift
//  SampleFirebase
//
//  Created by ShinokiRyosei on 2016/02/27.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import Firebase //Firebaseをインポート

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView! //送信したデータを表示するTableView
    
    var contentArray: [FIRDataSnapshot] = [] //Fetchしたデータを入れておく配列、この配列をTableViewで表示
    
    let ref = FIRDatabase.database().reference() //Firebaseのルートを宣言しておく
    
    
    var snap: FIRDataSnapshot!
    
    var selectedSnap: FIRDataSnapshot!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //データを読み込むためのメソッド
        self.read()
        
        //TableViewCellをNib登録、カスタムクラスを作成
        table.registerNib(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        
        table.delegate = self //デリゲートをセット
        table.dataSource = self //デリゲートをセット
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Cellの高さを調節
        table.estimatedRowHeight = 56
        table.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        //画面が消えたときに、Firebaseのデータ読み取りのObserverを削除しておく
        ref.removeAllObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //ViewControllerへの遷移のボタン
    @IBAction func didSelectAdd() {
        self.transition()
    }
    
    func read()  {
        //FIRDataEventTypeを.Valueにすることにより、なにかしらの変化があった時に、実行
        //今回は、childでユーザーIDを指定することで、ユーザーが投稿したデータの一つ上のchildまで指定することになる
        ref.child((FIRAuth.auth()?.currentUser?.uid)!).observeEventType(.Value, withBlock: {(snapShots) in
            if snapShots.children.allObjects is [FIRDataSnapshot] {
                print("snapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                
                print("snapShot...\(snapShots)") //読み込んだデータをプリント
                
                self.snap = snapShots
                
            }
            self.reload(self.snap)
        })
    }
    
    //読み込んだデータは最初すべてのデータが一つにまとまっているので、それらを分割して、配列に入れる
    func reload(snap: FIRDataSnapshot) {
        if snap.exists() {
            print(snap)
            //FIRDataSnapshotが存在するか確認
            contentArray.removeAll()
            //1つになっているFIRDataSnapshotを分割し、配列に入れる
            for item in snap.children {
                contentArray.append(item as! FIRDataSnapshot)
            }
            // ローカルのデータベースを更新
            ref.child((FIRAuth.auth()?.currentUser?.uid)!).keepSynced(true)
            //テーブルビューをリロード
            table.reloadData()
        }
    }
    
    func delete(deleteIndexPath indexPath: NSIndexPath) {
        ref.child((FIRAuth.auth()?.currentUser?.uid)!).child(contentArray[indexPath.row].key).removeValue()
        contentArray.removeAtIndex(indexPath.row)
    }
    
    //timestampで保存されている投稿時間を年月日に表示形式を変換する
    func getDate(number: NSTimeInterval) -> String {
        let date = NSDate(timeIntervalSince1970: number)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.stringFromDate(date)
    }
    //ViewControllerへの遷移
    func transition() {
        self.performSegueWithIdentifier("toView", sender: self)
    }
    
    func didSelectRow(selectedIndexPath indexPath: NSIndexPath) {
        //ルートからのchildをユーザーのIDに指定
        //ユーザーIDからのchildを選択されたCellのデータのIDに指定
        //removeValueで削除
        self.selectedSnap = contentArray[indexPath.row]
        //ローカルの配列からも削除
        self.transition()
    }
    
    //スワイプ削除のメソッド
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //デリートボタンを追加
        if editingStyle == .Delete {
            //選択されたCellのNSIndexPathを渡し、データをFirebase上から削除するためのメソッド
            self.delete(deleteIndexPath: indexPath)
            //TableView上から削除
            table.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.didSelectRow(selectedIndexPath: indexPath)
    }
    
    //セルの数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    //返すセルを決める
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //xibとカスタムクラスで作成したCellのインスタンスを作成
        let cell = table.dequeueReusableCellWithIdentifier("ListCell") as! ListTableViewCell
        
        //配列の該当のデータをitemという定数に代入
        let item = contentArray[indexPath.row]
        //itemの中身を辞書型に変換
        let content = item.value as! Dictionary<String, AnyObject>
        //contentという添字で保存していた投稿内容を表示
        cell.contentLabel.text = String(content["content"]!)
        //dateという添字で保存していた投稿時間をtimeという定数に代入
        let time = content["date"] as! NSTimeInterval
        //getDate関数を使って、時間をtimestampから年月日に変換して表示
        cell.postDateLabel.text = self.getDate(time/1000)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toView" {
            let view = segue.destinationViewController as! ViewController
            if let snap = self.selectedSnap {
                view.selectedSnap = snap
            }
        }
    }
    
    func query() {
        //dateをキーに順に並べる
        ///ref.child((FIRAuth.auth()?.currentUser?.uid)!).queryOrderedByChild("date").observeEventType(.Value, withBlock: { (snap) in
        //    print(snap)
        //})
        
        
        //"content"の中に、"MIB"という単語があるかを調べる
        ref.child((FIRAuth.auth()?.currentUser?.uid)!).queryOrderedByChild("content").queryEqualToValue("MIB").observeEventType(.Value, withBlock: { (snap) in
            print(snap)
        })
    }
    
}
