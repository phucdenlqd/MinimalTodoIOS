//
//  TaskCell.swift
//  MinimalTodo
//
//  Created by Phuc Nguyen on 03/01/2019.
//  Copyright © 2019 Phuc Nguyen. All rights reserved.
//

import UIKit
import UserNotifications
class TaskCell: UITableViewCell {
    var timer: Timer?
    var titleTask: String?
    var dateTask: String?
    
    var timeInterval: TimeInterval? {
        didSet {
            startTimer()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func startTimer(){
        if(round(timeInterval!) > 0){
             timer = Timer.scheduledTimer(timeInterval: timeInterval!, target: self, selector: #selector(TaskCell.runNoti), userInfo: nil, repeats: false)
        }
        
//        print("\(timer)")
    }
    
    @objc func runNoti(){
        let content = UNMutableNotificationContent()
        content.title = "TO DO :"
        content.subtitle = titleTask!
        content.body = dateTask!
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "timeDone", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }

}
