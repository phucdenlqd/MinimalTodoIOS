//
//  File.swift
//  MinimalTodo
//
//  Created by Phuc Nguyen on 01/01/2019.
//  Copyright © 2019 Phuc Nguyen. All rights reserved.
//

import Foundation

public class Task{
    var id:Int
    var title : String
    var date : String
    init(title:String,date:String){
        self.id=0
        self.title=title
        self.date=date
    }
    init(id:Int,title:String,date:String){
        self.id=id
        self.title=title
        self.date=date
    }
    func getTitle() -> String {
        return self.title
    }
    func getDate() -> String {
        return self.date
    }
    func getId() -> Int {
        return self.id
    }
}
