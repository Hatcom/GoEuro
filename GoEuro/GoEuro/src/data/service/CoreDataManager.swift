//
//  CoreDataManager.swift
//  iMsgStickerpipe
//
//  Created by vlad on 9/22/16.
//  Copyright © 2016 908. All rights reserved.
//

import UIKit
import CoreData

@objc class CoreDataManager: NSObject {
    static let shared = CoreDataManager()

    let mainContext: NSManagedObjectContext

    let managedObjectModel: NSManagedObjectModel
    private let persistentStore: NSPersistentStore
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator

    override private init() {
        let frameworkBundle = Bundle(for: CoreDataManager.self)

        let urlForDataModel = frameworkBundle.url(forResource: "RidesModel", withExtension: "momd")!

        managedObjectModel = NSManagedObjectModel(contentsOf: urlForDataModel)!
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let storeURL = documentsURL.appendingPathComponent("GoEuroModel.sqlite")

        let options: [String: Any] = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true, NSSQLitePragmasOption: ["journal_mode": "WAL"]]

        persistentStore = try! persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)

        let backgroundQueueContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundQueueContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        let mainQueueContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        let analyticsBackgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

        backgroundQueueContext.persistentStoreCoordinator = persistentStoreCoordinator
        mainQueueContext.persistentStoreCoordinator = persistentStoreCoordinator
        analyticsBackgroundContext.persistentStoreCoordinator = persistentStoreCoordinator

        mainContext = mainQueueContext
    }

    func removeObjects(_ objects: [NSManagedObject]) {
        for object in objects {
            mainContext.delete(object)
        }
    }
    
    func saveIfNeeded() throws {
        if mainContext.hasChanges {
            try mainContext.save()
        }
    }
}


extension NSManagedObject {
    static func ge_findAll(withPredicate predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int = 0, context: NSManagedObjectContext = CoreDataManager.shared.mainContext) -> [NSManagedObject]? {
        let request: NSFetchRequest<NSFetchRequestResult> = ge_fetchRequest()
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        request.fetchLimit = fetchLimit

        var objects: [Any]? = nil

        context.performAndWait {
            do {
                objects = try context.fetch(request)
            } catch {
                print("Fetching error")
            }
        }

        return objects as? [NSManagedObject]
    }

    static func ge_fetchRequest<T>() -> NSFetchRequest<T> {
        return NSFetchRequest(entityName: String(describing: self))
    }

    static func ge_object(withUniqueAttribute attribute: String, value: AnyObject, context: NSManagedObjectContext = CoreDataManager.shared.mainContext) -> Self {
        return object(withUniqueAttribute: attribute, value: value, context: context)
    }

    private static func object<T: NSManagedObject>(withUniqueAttribute attribute: String, value: AnyObject?, context: NSManagedObjectContext) -> T {
        var object: T? = nil

        context.performAndWait {
            do {
                if let value = value {
                    let request: NSFetchRequest<NSFetchRequestResult> = ge_fetchRequest()
                    request.predicate = NSPredicate(format: "%K == %@", argumentArray: [attribute, value])
                    object = try context.fetch(request).first as? T
                } else {
                    object = nil
                }
            } catch {
                print("Fetching error")
            }

            if object == nil {
                object = NSEntityDescription.insertNewObject(forEntityName: String(describing: self), into: context) as? T
                object?.setValue(value, forKey: attribute)
            }
        }

        return object!
    }
}
