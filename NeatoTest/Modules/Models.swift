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
    var cities: [City] = []
    
    weak var modelResultUser: ModelResultProtocol?
    
    init(modelResultUser: ModelResultProtocol?) {
        self.modelResultUser = modelResultUser
    }
    
    func saveToCoreData(array: CitiesDic) {
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
        if let cities = array.cities {
            for cityName in cities {
                guard let name = cityName.name else {
                    self.deleteData()
                    modelResultUser?.saveFailed()
                    return
                }
                
                
                // 3
                city.setValue(name, forKeyPath: "name")
                
                // 4
                do {
                    try managedContext.save()
                    citiesManagedObject.append(city)
                } catch let error as NSError {
                    self.deleteData()
                    modelResultUser?.saveFailed()
                    
                    print("Could not save. \(error), \(error.userInfo)")
                    return
                    
                }
            }
        }
        self.fillCitiesDic(citiesManagedObject)
        
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
            NSFetchRequest<NSManagedObject>(entityName: "Cities")
        
        //3
        do {
            let citiesManagedObject = try managedContext.fetch(fetchRequest)
            fillCitiesDic(citiesManagedObject)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func fillCitiesDic(_ citiesManagedObject: [NSManagedObject]){
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
    
    private func deleteData() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Cities")
        
        //3
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

struct City {
    var name : String?
    var temprature: Int?
    static let pictureURlFresh = PicURLs.randomPicFresh
    static let pictureURLGray = PicURLs.randomPicUgly
}

struct CitiesDic: Codable {
    var cities: [CityName]?
}

struct CityName: Codable {
    var name: String?
}
