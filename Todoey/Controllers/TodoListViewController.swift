//
//  ViewController.swift
//  Todoey
//
//  Created by Lucas Almeida on 26/01/19.
//  Copyright © 2019 Lucas Almeida. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

//    let context = CoreDataManager.sharedManager.persistentContainer.viewContext
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(Pathing.ItemsPlist.rawValue)
//    let defaults = UserDefaults.standard
//    var itemArray = [Item]()
    
    var itemArray: Results<Item>?

    var selectedCategory: Category? {
        didSet {
//            loadItems()
            loadRealm()
        }
    }
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        if let items = defaults.array(forKey: Persistence.UserDefaultsItemArray.rawValue) as? [Item] {
//            itemArray = items
//        }
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        tableView.separatorStyle = .none
        searchBar.delegate = self
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colorHex = selectedCategory?.cellColor else { fatalError("ColorHex error") }
        navigationItem.title = selectedCategory?.name.capitalized
        updateNavBar(withHexCode: colorHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "#1D9BF6")
    }
    
    //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colorHexCode: String) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation Bar error") }
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError("Navbar color error") }
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title.capitalized
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let color = UIColor(hexString: selectedCategory!.cellColor!)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemArray!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let addItemAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Fail to save")
                }
            }
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(addItemAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Save and load with Realm
    
    func saveRealm(item: Object) {
        do {
            try realm.write {
                realm.add(item)
            }
            tableView.reloadData()
        } catch {
            print("Error trying to save")
        }
    }
    
    func loadRealm() {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe

    override func updateModel(at indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print(error)
            }
        }
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadRealm()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

// MARK: - Core Data

// MARK - Tableview Delegate Methods

//override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    itemArray![indexPath.row].done = !itemArray![indexPath.row].done
//    itemArray[indexPath.row].setValue(false, forKey: "done")
//    saveContext()
//    tableView.deselectRow(at: indexPath, animated: true)
//    tableView.reloadData()
//}
//
//// MARK - Add New Items
//@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
//    var textField = UITextField()
//    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
//
//    let addItemAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
//        //            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        //            let newItem = Item(context: self.context)
////        self.tableView.reloadData()
//        newItem.done = false
//        newItem.parentCategory = self.selectedCategory
//        self.itemArray.append(newItem)
//        self.saveContext()
////        self.defaults.set(self.itemArray, forKey: Persistence.UserDefaultsItemArray.rawValue)
//    }
//
//    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//    alert.addTextField { (alertTextField) in
//        alertTextField.placeholder = "Create new item"
//        textField = alertTextField
//    }
//
//    alert.addAction(addItemAction)
//    alert.addAction(cancelAction)
//
//    present(alert, animated: true, completion: nil)
//}

//    func saveContext() {
//        // SAVE WITH COREDATA
//
//        do {
//            try context.save()
//        } catch {
//            print(error)
//        }
//
//        // SAVE WITH CODABLE
////        let encoder = PropertyListEncoder()
////
////        do {
////            let data = try encoder.encode(self.itemArray)
////            try data.write(to: self.dataFilePath!)
////        } catch {
////            print(error)
////        }
//
//        tableView.reloadData()
//    }
//
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicates: NSCompoundPredicate? = nil) {
//        // LOAD WITH COREDATA
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let unwrapPredicates = predicates {
//            let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [
//                categoryPredicate,
//                unwrapPredicates
//            ])
//
//            request.predicate = compound
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print(error)
//        }
//
//        tableView.reloadData()
//
//        // LOAD WITH CODABLE
////        if let data = try? Data(contentsOf: dataFilePath!) {
////            let decoder = PropertyListDecoder()
////            do {
////                itemArray = try decoder.decode([Item].self, from: data)
////            } catch {
////                print(error)
////            }
////        }
//    }

//override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//    if editingStyle == .delete {
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .fade)
//        saveContext()
//    }
//}

// MARK: - Search Bar with Core Data

//extension TodoListViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        request.predicate = NSPredicate(format: ItemPredicates.Title.rawValue + " CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: ItemPredicates.Title.rawValue, ascending: true)]
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
//            request.predicate!
//        ])
//        searchBar.text! != "" ? loadItems(with: request, predicates: compoundPredicate) : loadItems()
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}

