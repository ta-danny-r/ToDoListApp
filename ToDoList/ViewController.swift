//
//  ViewController.swift
//  ToDoList
//
//  Created by Danny on 10/14/21.
//

import UIKit


import UIKit
import CoreData

class ViewController: UIViewController {
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var todoItems = [TodoItem]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllTodoItems()
    }
    
    @IBAction func newItemCreated(_ segue: UIStoryboardSegue) {
        
        let controller = segue.source as! NewItemViewController
        let todoItem = NSEntityDescription.insertNewObject(forEntityName: "TodoItem", into: moc) as! TodoItem
        
        todoItem.title = controller.titleTextField.text
        todoItem.notes = controller.notesTextView.text
        todoItem.dateToComplete = controller.datePicker.date as Date?
        todoItem.completed = false
        
        saveManagedObjectContext()

        todoItems.append(todoItem)
        tableView.reloadData()
    }
    
    func fetchAllTodoItems() {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItem")
            self.todoItems = try moc.fetch(request) as! [TodoItem]
        } catch {
            print(error)
        }
    }
    
    func saveManagedObjectContext() {
        do {
            try moc.save()
        } catch {
            print(error)
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoItemTableViewCell
        let todoItem = todoItems[indexPath.row]
        cell.titleLabel.text = todoItem.title
        cell.notesLabel.text = todoItem.notes
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: todoItem.dateToComplete as! Date)
        cell.dateLabel.text = dateString
        
        if todoItem.completed {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let todoItem = self.todoItems[indexPath.row]
        todoItem.completed = !todoItem.completed
        saveManagedObjectContext()
        
        let cell = tableView.cellForRow(at: indexPath) // returns a UITABLEVIEWCELL
        if todoItem.completed {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        
    }
    
}

