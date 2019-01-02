//
//  AddTodoViewController.swift
//  MinimalTodo
//
//  Created by Phuc Nguyen on 01/01/2019.
//  Copyright © 2019 Phuc Nguyen. All rights reserved.
//

import UIKit

class AddTodoViewController: UIViewController {


    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var txtFieldTitle: UITextField!
    @IBOutlet weak var containerDate: UIView!
    @IBOutlet weak var swDate: UISwitch!
    var hideDate:Bool = false
    var date:String = ""
    var time:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtFieldTitle.borderStyle = .none
        self.txtFieldTitle.backgroundColor = UIColor.clear
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: txtFieldTitle.frame.size.height - width, width: txtFieldTitle.frame.size.width, height: txtFieldTitle.frame.size.height)
        border.borderWidth = width
        txtFieldTitle.layer.addSublayer(border)
        txtFieldTitle.layer.masksToBounds = true
        
        containerDate.isHidden=hideDate
        swDate.isOn = !hideDate
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        setDateAndTime(date:dateFormatter.string(from: now),time:timeFormatter.string(from: now))
        sendDateAndTimeToChild(date: self.date, time: self.time)
    }
    
    func setDateAndTime(date:String,time:String){
        self.date = date
        self.time = time
    }
    
    @IBAction func swDateAction(_ sender: UISwitch) {
        hideDate = !sender.isOn
        containerDate.isHidden=hideDate
    }
    
    @IBAction func btnSendAction(_ sender: UIButton) {
        print(self.date)
    }
    
    func sendDateAndTimeToChild(date:String,time:String){
        let cvc = children.last as! DateTimeViewController
        cvc.dateAndTimeFromParent(date: date, time: time)
    }
    
    func dateAndTimeFromContainer(date:String,time:String) {
        setDateAndTime(date: date, time: time)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        if(segue.identifier == "dateTimeSegue"){
//            let dateTimeController = segue.destination as! DateTimeViewController
//            dateGot = dateTimeController.txtFieldDate.text
//
//        }
//    }
    

}
