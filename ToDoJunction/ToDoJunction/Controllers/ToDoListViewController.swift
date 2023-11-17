//
//  ToDoListViewController.swift
//  ToDoJunction
//
//  Created by Aaraiz Wasim on 31/10/2023.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]:: \(dataFilePath) :: [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[")

        
//        let newItem = Item()
//        newItem.title = "Find Nemo"
//        itemArray.append(newItem)
//        
//        let newItem1 = Item()
//        newItem1.title = "Practice Maths"
//        itemArray.append(newItem1)
//        
//        let newItem2 = Item()
//        newItem2.title = "Eat Food"
//        itemArray.append(newItem2)

        loadItems()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addBUttonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new To-Do item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { action in
            //once user clicks add item
            if let text = textfield.text {
                let newItem = Item(context: self.context)
                newItem.title = text
                newItem.done = false
                self.itemArray.append(newItem)
                self.saveItems()
            }
            
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textfield = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
    
    func saveItems(){
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching context: \(error)")
        }
    }
}


