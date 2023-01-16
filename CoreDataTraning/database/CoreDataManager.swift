//
//  CoreDataManager.swift
//  CoreDataTraning
//
//  Created by mobin on 1/8/23.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager:CoreDataOperationProtocol {

    

    func deleteDataById(itemId: UUID) {
        items?.forEach({ item in
            if item.itemID == itemId {
                self.context.delete(item)
            }
                
        })
        do {
            try self.context.save()
            let request = Item.fetchRequest() as NSFetchRequest<Item>
            self.items = try context.fetch(request)
        } catch {
            fatalError()
        }
    }
    

    func updateItem(itemId: UUID, newStr: String) {
        items?.forEach({ item in
            if item.itemID == itemId{
                item.setValue(newStr, forKey: "name")
            }
        })
        do {
            try self.context.save()
            let request = Item.fetchRequest() as NSFetchRequest<Item>
            self.items = try context.fetch(request)
        } catch {
            fatalError()
        }
    }
    

    
    
    private init() {}
    static let shared = CoreDataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var items:[Item]?
    
    func getItems() -> [Item]? {
        return items
    }
    /// Added one garment
   
    func addData(name:String, date:Date, imageData:Data?) {
        let newGarment = Item(context: self.context)
        newGarment.itemID = UUID()
        newGarment.name = name
        newGarment.date = date
        newGarment.image = imageData
        do {
            try self.context.save()
            let request = Item.fetchRequest() as NSFetchRequest<Item>
            self.items = try context.fetch(request)
        } catch {
            fatalError()
        }
        
        print("note data is saved")
    }
    
    
    
    /// Sorted datas populated by Alpha or Creation time
    
    func sortData(segmentIndex:Int){
        var sort = NSSortDescriptor()
        switch segmentIndex {
        case 0: sort = NSSortDescriptor(key: "name", ascending: true)
        case 1: sort = NSSortDescriptor(key: "date", ascending: false)
        default: break
        }
        
        do {
            let request = Item.fetchRequest() as NSFetchRequest<Item>
            request.sortDescriptors = [sort]
            self.items = try context.fetch(request)
        } catch {
             fatalError()
        }
    }

    
    /// Deleted a data populated
    
    func deleteData(index:Int) {
        let garmentToRemove = self.items![index]
        self.context.delete(garmentToRemove)
        
        do {
            try self.context.save()
            let request = Item.fetchRequest() as NSFetchRequest<Item>
            self.items = try context.fetch(request)
        } catch {
            fatalError()
        }
    }
}

protocol CoreDataOperationProtocol {
    func addData(name:String, date:Date, imageData:Data? )
    func sortData(segmentIndex:Int)
    func deleteData(index:Int)
    func deleteDataById(itemId: UUID)
    func getItems() -> [Item]?
    func updateItem(itemId:UUID, newStr:String)
}
