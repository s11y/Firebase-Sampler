//
//  Data.swift
//  SampleFirebase
//
//  Created by ShinokiRyosei on 2016/02/22.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import Firebase

class Data: FIRDataSnapshot{
    var createdAt: NSString!
    var content: NSString!
    var user: String!
    
    init(createdAt: NSString, content: NSString) {
        self.createdAt = createdAt
        self.content = content
        self.user = FIRAuth.auth()?.currentUser?.uid
    }
}
