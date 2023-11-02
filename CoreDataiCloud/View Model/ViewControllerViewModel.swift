//
//  ViewControllerViewModel.swift
//  CoreDataiCloud
//
//  Created by Hao Yu Yeh on 2023/11/2.
//
import UIKit
import CoreData

protocol ViewControllerViewModelDelegate: AnyObject{
    func itemDidUpdate()
}

class ViewControllerViewModel: NSObject {
    
    weak var delegate: ViewControllerViewModelDelegate?
    // it will take care of any updates in the managedContext
    var itemFetchResultsController: NSFetchedResultsController<Item>?
    
    init(delegate: ViewControllerViewModelDelegate) {
        super.init()
        self.delegate = delegate
        setFetchResultsController()
        fetchItems()
    }
}

extension ViewControllerViewModel {
    func setFetchResultsController() {
        let fetchRequest = NSFetchRequest<Item>(entityName: "Item")
        // sortDescriptor cannot be avoided
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        itemFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PersistenceService.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        itemFetchResultsController?.delegate = self
    }
    
    func fetchItems() {
        do {
            try itemFetchResultsController?.performFetch()
        } catch  {
            print("fetching items failed")
        }
    }
    
    func addNewItem() {
        let newItem = Item(context: PersistenceService.managedContext)
        newItem.name = "item" + "\((itemFetchResultsController?.fetchedObjects?.count ?? 0) + 1)"
        PersistenceService.share.saveContext()
    }
    
    func deleteItem() {
        guard let firstItem = itemFetchResultsController?.object(at: IndexPath(item: 0, section: 0)) else {
            return
        }
        PersistenceService.managedContext.delete(firstItem)
        PersistenceService.share.saveContext()
    }
}

extension ViewControllerViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // inform the view controller if any data updated
        delegate?.itemDidUpdate()
    }
}

extension ViewControllerViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemFetchResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = itemFetchResultsController?.object(at: indexPath).name
        cell.contentConfiguration = content
        
        return cell
    }
}
