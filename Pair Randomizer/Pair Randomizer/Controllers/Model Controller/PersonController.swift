//
//  PersonController.swift
//  Pair Randomizer
//
//  Created by Hunter McNeil on 7/10/20.
//  Copyright © 2020 Hunter McNeil. All rights reserved.
//

import Foundation

class PersonController {
    
    static let shared = PersonController()
    
    var people: [Person] = []
    
    let defaults = UserDefaults.standard
    
    func addName(name: String) {
        let newPerson = Person(name: name)
        people.append(newPerson)
        saveToPersistenceStore()
    }
    
    func deletePerson(person: Person) {
        guard let indexToDelete = people.firstIndex(of: person) else {return}
        people.remove(at: indexToDelete)
        saveToPersistenceStore()
    }
    
    //MARK: - Persistence
    func creatPersistenceStore() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = url[0].appendingPathComponent("Pair Randomizer.json") // <-- Change file (app) name
        return fileURL
    }
    
    // Save
    func saveToPersistenceStore() {
        let jsonEncoder = JSONEncoder()
        
        do {
            let data = try jsonEncoder.encode(people) // <-- Change S.O.T
            try data.write(to: creatPersistenceStore())
        } catch {
            print("Error encoding our people: \(error) -- \(error.localizedDescription)") // <-- Update error message
        }
    }
    
    // Load
    func loadFromPersistenceStore() {
        let jsonDecoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: creatPersistenceStore())
            people = try jsonDecoder.decode([Person].self, from: data) // <-- Update S.O.T & Update the decoded Type
        } catch {
            print("Error decoding our data into people: \(error), \(error.localizedDescription)") // <-- Update error message
        }
    }
}
