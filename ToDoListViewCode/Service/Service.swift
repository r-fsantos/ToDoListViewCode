//
//  Service.swift
//  ToDoListViewCode
//
//  Created by Renato F. dos Santos Jr on 26/03/22.
//

import Foundation
import CoreData
import UIKit

typealias onCompletion = (String) -> Void

protocol serviceGetDataProtocol {
    func getData() -> [TarefaData]
}

protocol serviceSaveProtocol {
    func save(task: TarefaData, onCompletionHandler: onCompletion)
}

protocol serviceDeleteProtocol {
    func delete(taskUUID: String, onCompletionHandler: onCompletion)
}

class Service: serviceGetDataProtocol, serviceSaveProtocol, serviceDeleteProtocol {
    
    private let entity = "Tarefa"
    
    static var shared: Service = {
        let instance = Service()
        return instance
    }()
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func getData() -> [TarefaData] {
        var listTasks: [TarefaData] = []
        
        do {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
            
            guard let tasks = try getContext().fetch(fetchRequest) as? [NSManagedObject] else { return listTasks }
            
            for item in tasks {
                if let id = item.value(forKey: "id") as? UUID,
                   let title = item.value(forKey: "title") as? String,
                   let detail = item.value(forKey: "detail") as? String,
                   let isDone = item.value(forKey: "isDone") as? Bool {
                    
                    let task = TarefaData(id: id, title: title, detail: detail, isDone: isDone)
                    
                    listTasks.append(task)
                }
            }
        } catch {
            print("Error with request: \(error)")
        }
        
        return listTasks
    }
    
    func save(task: TarefaData, onCompletionHandler: (String) -> Void) {
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: entity, in: context) else { return }
        
        let transaction = NSManagedObject(entity: entity, insertInto: context)
        
        transaction.setValue(task.id, forKey: "id")
        transaction.setValue(task.title, forKey: "title")
        transaction.setValue(task.detail, forKey: "detail")
        transaction.setValue(task.isDone, forKey: "isDone")
        
        do {
            try context.save()
            
            onCompletionHandler("Success")
        } catch let error as NSError {
            print("Save error: \(error.localizedDescription)")
        }
    }
    
    func delete(taskUUID: String, onCompletionHandler: (String) -> Void) {
        let context = getContext()
        
        let predicate = NSPredicate(format: "id == %@", "\(taskUUID)")
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResults = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            if let entityDelete = fetchResults.first {
                context.delete(entityDelete)
            }
            
            try context.save()
            
            onCompletionHandler("Successful delete")
        } catch let error as NSError {
            print("Delete error: \(error)")
        }
    }
}

extension Service {
    func filterTasksByStatus(tasks: [TarefaData]) -> [[TarefaData]] {
        var filteredTasks: [[TarefaData]] = []
        var toBeDoneTasks: [TarefaData] = []
        var doneTasks: [TarefaData] = []
        
        for item in tasks {
            if item.isDone {
                doneTasks.append(item)
            } else {
                toBeDoneTasks.append(item)
            }
        }
        
        filteredTasks.append(toBeDoneTasks)
        filteredTasks.append(doneTasks)
        
        return filteredTasks
    }
}
