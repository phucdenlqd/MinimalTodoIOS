//
//  TaskTableViewController.swift
//  MinimalTodo
//
//  Created by Phuc Nguyen on 01/01/2019.
//  Copyright © 2019 Phuc Nguyen. All rights reserved.
//

import UIKit
import SQLite

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
        
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
        let task1 = Task(title: "dihoc", date: "12/05/2018")
        let task2 = Task(title: "di choi", date: "26/04/2011")
        let task3 = Task(title: "di", date: "26/04/2011")
        insertTableTask(task: task1)
        insertTableTask(task: task2)
        insertTableTask(task: task3)

        deleteTask(id: 3)
        tasks = selectAllTasks()
        print ("--> viewDidLoad fin")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTask", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = "\(tasks[indexPath.row].getId()). \(tasks[indexPath.row].getTitle())"
        cell.detailTextLabel?.text = "\(tasks[indexPath.row].getDate())"
        return cell
    }
   

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
