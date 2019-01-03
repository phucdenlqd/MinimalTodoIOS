//
//  TaskTableViewController.swift
//  MinimalTodo
//
//  Created by Phuc Nguyen on 01/01/2019.
//  Copyright © 2019 Phuc Nguyen. All rights reserved.
//

import UIKit
import SQLite
import UserNotifications
public var listTimer: [Timer] = []
class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var myTableView: UITableView!
    var database: Connection!
    let task_table = Table("task")
    let task_id = Expression<Int>("id")
    let task_title = Expression<String>("title")
    let task_date = Expression<String>("date")
    
//    var pk = 1000;           // valeur de départ pour la primary key
//    var tableExist = false
    
    var tasks:[Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonAdd.layer.cornerRadius = buttonAdd.frame.height / 2
        print(listTimer.count)
        for timer in listTimer{
            timer.invalidate()
        }
        listTimer.removeAll()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.hidesBackButton=true
        print ("--> viewDidLoad debut")
        // Do any additional setup after loading the view, typically from a nib.
        do {
            let documentDirectory = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl=documentDirectory.appendingPathComponent("task").appendingPathExtension("sqlite3")
            let base = try Connection(fileUrl.path)
            self.database = base;
        }
        catch {
            print (error)
        }
        
        createTableTask();
//        let task1 = Task(title: "dihocccfcfffdgfdgdfgdfgdfgdfgdfgdfgdfgfdgdfgfdgdfgdfgdfgdfgdfgdf", date: "12/05/2018")
//        let task2 = Task(title: "di choi", date: "26/04/2011")
//        let task3 = Task(title: "di", date: "26/04/2011")
//        insertTableTask(task: task1)
//        insertTableTask(task: task2)
//        insertTableTask(task: task3)
        tasks = selectAllTasks()
        print ("--> viewDidLoad fin")
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
        
//        notifi(timeInterval: 5)
    }

    // MARK: - Table view data source
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTask", for: indexPath) as! TaskCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        if(tasks[indexPath.row].getDate() != ""){
            let dateTimer = dateFormatter.date(from: tasks[indexPath.row].getDate())
            if(round(dateTimer!.timeIntervalSinceNow) > 0){
                notifi(timeInterval: dateTimer!.timeIntervalSinceNow, titleTask: tasks[indexPath.row].getTitle(), dateTask: tasks[indexPath.row].getDate(), id: tasks[indexPath.row].getId())
            }
        }
//        print("\(self.listTimer[indexPath.row])")
        
        // Configure the cell...
        cell.labelTitleTask.text = "\(tasks[indexPath.row].getId()). \(tasks[indexPath.row].getTitle())"
        cell.labelSubtitleTask.text = "\(tasks[indexPath.row].getDate())"
        cell.labelLogo.text=String(tasks[indexPath.row].getTitle().prefix(1)).uppercased()
        if  tasks[indexPath.row].getDate() == ""{
            cell.labelSubtitleTask.isHidden=true
            cell.labelTitleTask.frame = CGRect(x: 67, y: (cell.frame.height - cell.labelTitleTask.frame.height) / 2, width: cell.labelTitleTask.frame.width, height: cell.labelSubtitleTask.frame.height)
        }
        return cell
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let task = tasks[indexPath.row]
            deleteTask(id: task.getId())
            tasks.remove(at: indexPath.row)
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(task.getId())"])
            myTableView.reloadData()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }
    func notifi(timeInterval: TimeInterval, titleTask: String, dateTask: String, id: Int){
        let content = UNMutableNotificationContent()
        
        //adding title, subtitle, body and badge
        content.title = "TODO:"
        content.subtitle = titleTask
        content.body = dateTask
        content.badge = 1
        
        //getting the notification trigger
        //it will be called after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: "\(id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        
        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Modify"){(action,view,completion) in
            completion(false)
//            print("chuyencontroller ")
//            let task = self.tasks[indexPath.row]
//            self.deleteTask(id: task.getId())
//            self.tasks.remove(at: indexPath.row)
//            self.myTableView.reloadData()
            let task = self.tasks[indexPath.row]
            
            let addToDoViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddToDo") as! AddTodoViewController
            addToDoViewController.actionType = "modify"
            addToDoViewController.toDoTitle = task.getTitle()
            addToDoViewController.toDoId=task.getId()
            
            if  task.getDate() != "" {
                print(task.getDate())
                var dateStringArray=task.getDate().split(separator: " ")
                addToDoViewController.date=String(dateStringArray[0])
                addToDoViewController.time=String(dateStringArray[1])
            }
            
            self.navigationController?.pushViewController(addToDoViewController, animated: true)
        }
        action.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [action])
    }
    
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        myTableView.deselectRow(at: indexPath, animated: true)
//
//        let task = tasks[indexPath.row]
//
//        let addToDoViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddToDo") as! AddTodoViewController
//        addToDoViewController.actionType = "modify"
//        addToDoViewController.toDoTitle = task.getTitle()
//        addToDoViewController.toDoId=task.getId()
//
//        if  task.getDate() != "" {
//            print(task.getDate())
//            var dateStringArray=task.getDate().split(separator: " ")
//            addToDoViewController.date=String(dateStringArray[0])
//            addToDoViewController.time=String(dateStringArray[1])
//        }
//
//        self.navigationController?.pushViewController(addToDoViewController, animated: true)
//    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func doAddTask(title:String,date:String,time:String){
        do {
            let documentDirectory = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl=documentDirectory.appendingPathComponent("task").appendingPathExtension("sqlite3")
            let base = try Connection(fileUrl.path)
            self.database = base;
        }
        catch {
            print (error)
        }
        var stringDateTime:String=date+" "+time
        print(stringDateTime)
        if stringDateTime == " "{
            stringDateTime=""
        }
        let task1 = Task(title: title, date: stringDateTime)
        insertTableTask(task: task1)
        print("doneee")
    }
    
    func doUpdateTask(idTask:Int,title:String,date:String,time:String){
        do {
            let documentDirectory = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl=documentDirectory.appendingPathComponent("task").appendingPathExtension("sqlite3")
            let base = try Connection(fileUrl.path)
            self.database = base;
        }
        catch {
            print (error)
        }
        var stringDateTime:String=date+" "+time
        print(stringDateTime)
        if stringDateTime == " "{
            stringDateTime=""
        }
        let task1 = Task(id:idTask, title: title, date: stringDateTime)
        updateTask(id: idTask, newTask: task1)
    }
    
    
    
    
    
    func createTableTask() {
        print ("--> createTableTask debut")
//        if !self.tableExist {
//            self.tableExist = true
//            // Instruction pour faire un drop de la table USERS
//            let dropTable = self.task_table.drop(ifExists: true)
//            // Instruction pour faire un create de la table USERS
//            let createTable = self.task_table.create { table in
//                table.column(self.task_id, primaryKey: .autoincrement)
//                table.column(self.task_title)
//                table.column(self.task_date)
//            }
//            do {// Exécution du drop et du create
//                try self.database.run(dropTable)
//                try self.database.run(createTable)
//                print ("Table task est créée")
//            }
//            catch {
//                print (error)
//            }
//        }
        let createTable = self.task_table.create(ifNotExists:true) { table in
            table.column(self.task_id, primaryKey: .autoincrement)
            table.column(self.task_title)
            table.column(self.task_date)
        }
        do {
            try self.database.run(createTable)
                print ("Table task est créée")
            }
            catch {
                print (error)
        }
        
        print ("--> createTableTask fin")
    }
    
    func insertTableTask(task:Task) {
        print ("--> insertTableTask debut")
        let insertTask = self.task_table.insert(self.task_title <- task.getTitle(), self.task_date <- task.getDate())
        do {
            try self.database.run(insertTask)
            print ("InsertTask ok")
        }
        catch {
            print (error)
            print ("--> insertTableTask fin")
        }
    }
    
    func selectTask(id:Int) -> Task{
        print ("--> select Task")
        var task_result = Task(id: 0, title: "", date: "")
        do {
            let tasks = try self.database.prepare(self.task_table.filter(task_id == id))
            for task in tasks{
                task_result = Task(id: task[self.task_id],title: task[self.task_title],date: task[self.task_date])
            }
        } catch{
            print("--> selectTask est en erreur")
        }
        print ("--> selectTask fin")
        return task_result
    }
    
    func selectAllTasks() -> [Task] {
        print ("--> selectAllTasks debut")
        var tasks_result:[Task]=[]
        do {
            let tasks = try self.database.prepare(self.task_table)
            for task in tasks {
                let task_result = Task(id: task[self.task_id],title: task[self.task_title],date: task[self.task_date])
                tasks_result.append(task_result)
            }
        } catch{
            print("--> selectAllTasks est en erreur")
        }
        print ("--> selectAllTasks fin")
        return tasks_result
    }
    
    func updateTask(id:Int,newTask:Task) {
        print ("--> updateTask debut")
        let task = self.task_table.filter(self.task_id == id)
        let updateUser = task.update (self.task_title <- newTask.getTitle(), self.task_date <- newTask.getDate())
        do {
            try self.database.run(updateUser)
            print ("Task", id," modifié")
        }
        catch{
            print("--> updateTask est en erreur")
        }
        print ("--> updateTask fin")
    }
    
    func deleteTask(id : Int ) {
        print ("--> deleteTask debut")
        let task = self.task_table.filter(self.task_id == id)
        let deleteTask = task.delete()
        do {
            try self.database.run(deleteTask)
            print ("Suppression task ", id, " effectuée même s'il n'existe pas !")
        }
        catch{
            print("--> deleteTask est en erreur")
        }
        print ("--> deleteTask fin")
    }
}
