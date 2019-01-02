//
//  DateTimeViewController.swift
//  MinimalTodo
//
//  Created by Phuc Nguyen on 02/01/2019.
//  Copyright © 2019 Phuc Nguyen. All rights reserved.
//

import UIKit
var dataDate: String = ""
var dataTime: String = ""
class DateTimeViewController: UIViewController {
    
    var aaa:String = "bb"
    @IBOutlet weak var txtFieldTime: UITextField!
    var datePicker: UIDatePicker?
    @IBOutlet weak var txtFieldDate: UITextField!
    var timePicker: UIDatePicker?
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = UIDatePicker()
        timePicker = UIDatePicker()
        
        datePicker?.datePickerMode = .date
        timePicker?.datePickerMode = .time
        
        datePicker?.addTarget(self, action: #selector(DateTimeViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        timePicker?.addTarget(self, action: #selector(DateTimeViewController.timeChanged(timePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DateTimeViewController.viewTapped(gestureRecogniser:)))

        view.addGestureRecognizer(tapGesture)
        txtFieldDate.inputView = datePicker
        txtFieldTime.inputView = timePicker
        // Do any additional setup after loading the view.
        
//        dataTime = txtFieldTime.text!
        
        
    }
    @objc func viewTapped(gestureRecogniser: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        txtFieldDate.text = dateFormatter.string(from: datePicker.date)

        view.endEditing(true)
    }
    
    @objc func timeChanged(timePicker: UIDatePicker){
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        txtFieldTime.text = timeFormatter.string(from: timePicker.date)
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
