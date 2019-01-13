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

    @IBOutlet weak var labelLogo: UILabel!
    @IBOutlet weak var labelTitleTask: UILabel!
    
    @IBOutlet weak var labelSubtitleTask: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelLogo.layer.cornerRadius = labelLogo.frame.height / 2
        labelLogo.backgroundColor = UIColor(red:   CGFloat(arc4random()) / CGFloat(UInt32.max),
                                            green: CGFloat(arc4random()) / CGFloat(UInt32.max),
                                            blue:  CGFloat(arc4random()) / CGFloat(UInt32.max),
                                            alpha: 1.0)
        labelLogo.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
    

