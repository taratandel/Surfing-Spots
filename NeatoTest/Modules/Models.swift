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
/// a class that takes care of changes in the core data
class CitiesCoreData: EntityProtocol {
    /// a copy of cities the we retrieved from the database
    var cities: [City] = []
    
    weak var modelResultUser: ModelResultProtocol?
    /**
     Initialized an instance of CititesCoreData for a specific user
     - Parameters:
        - modelResultUser: the client of the database
     */
    init(modelResultUser: ModelResultProtocol?) {
        self.modelResultUser = modelResultUser
    }
    
    /**
     This function will save a single entity to the data base
     - Parameters:
        - name: the string that we want to save at Cities entity
     */
    func saveToCoreData(name: String) {
        /// The managed object used to save the data
        var citiesManagedObject: [NSManagedObject] = []
        
        /// and instance of the current application
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        /// the context of the presistentContainer
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        /// an instance of the Cities entity
        let entity =
            NSEntityDescription.entity(forEntityName: "Cities",
                                       in: managedContext)!
        
        /// a managed of the to be saved
        let city = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        
        
        // sets the valie for our enitity
        city.setValue(name, forKeyPath: "name")
        
        
        do {
            try managedContext.save()
            citiesManagedObject.append(city)
        } catch let error as NSError {
            self.deleteData()
            modelResultUser?.saveFailed()
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    /**
     The function to retirieve an array of managedobjects of cities
     */
    func retrieveFromeCoreData() {
        /// and instance of the current application
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        /// and instance of the current application
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        /// the fetch request for entity Citites
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Cities")
        
        do {
            let citiesManagedObject = try managedContext.fetch(fetchRequest)
            fillCitiesDic(citiesManagedObject)
        } catch let error as NSError {
            self.modelResultUser?.saveFailed()
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    /**
     This function will convert the NSManagedObject to City Object
     - Parameters:
        - citiesManagedObject: the managed object to be converted
     */
    private func fillCitiesDic(_ citiesManagedObject: [NSManagedObject]){
        
        /// the array that keeps the instances of City
        var cityArray: [City] = []
        
        for city in citiesManagedObject {
            guard let name = city.value(forKey: "name") as? String else {
                self.modelResultUser?.saveFailed()
                return
            }
            var cityInstance = City()
            cityInstance.name = name
            cityArray.append(cityInstance)
        }
        cities = cityArray
        if cities.count > 0 {
            modelResultUser?.saveWasSuccessful()
        } else {
            modelResultUser?.saveFailed()
        }
        
    }
    
    /**
     empty the coreData when we have inconsistancies
     */
    private func deleteData() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Cities")
        
        do {
            let citiesManagedObject = try managedContext.fetch(fetchRequest)
            for city in citiesManagedObject {
                managedContext.delete(city)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

/// the structure of the City model
struct City {
    var name : String?
    var temp: Int?
}


// MARK: - Decodable models to use wirh decode function
struct CitiesDic: Codable {
    var cities: [CityName]?
}

struct CityName: Codable {
    var name: String?
}
