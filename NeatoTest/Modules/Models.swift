//
//  Models.swift
//  NeatoTest
//
//  Created by Tara Tandel on 18/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CitiesCoreData: EntityProtocol {
    var cities: CitiesDic?
        
    func saveToCoreData(name: String) {
        var citiesManagedObject: [NSManagedObject] = []

        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Cities",
                                       in: managedContext)!
        
        let city = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        city.setValue(name, forKeyPath: "name")
        
        // 4
        do {
            try managedContext.save()
            citiesManagedObject.append(city)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func retrieveFromeCoreData() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //3
        do {
           let citiesManagedObject = try managedContext.fetch(fetchRequest)
            fillCitiesDic(citiesManagedObject)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func fillCitiesDic(_ citiesManagedObject: [NSManagedObject]){
        for city in citiesManagedObject {
            print(city)
        }
    }
}

struct City: Codable {
    var name: String?
    var temprature: Int?
    var pictureURlFresh = PicURLs.randomPicFresh
    var pictureURLGray = PicURLs.randomPicUgly
}

struct CitiesDic: Codable {
    var cities:[City]
}

