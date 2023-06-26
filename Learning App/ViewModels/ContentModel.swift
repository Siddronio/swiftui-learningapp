//
//  ContentModel.swift
//  Learning App
//
//  Created by Jhonatan Sidrônio on 19/06/23.
//

import Foundation

class ContentModel: ObservableObject {
    
    @Published var modules = [Module]()
    
    var styleData:Data?
    
    init() {
        
        getLocalData()
    }
    
    func getLocalData() {
        
        // Get a URL to the JSON file
        let jsonUr1 = Bundle.main.url (forResource: "data", withExtension: "json")
        
        do {
            // Read the file into a data object
            let jsonData = try Data(contentsOf: jsonUr1!)
            
            // Try to decode the JSON into an array of modules
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
        
            // Assign parsed modules to modules property
            self.modules = modules
            
        }
        catch {
            // TODO log error
            print("Couldn't parse local data")
        }
        
        // Parse the style data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            // Read the file into a data object
            let styleData = try Data(contentsOf: styleUrl!)
            
            // Assign styleData to styleData property
            self.styleData = styleData
        }
        catch {
            // TODO log error
            print("Couldn't parse local data")
        }
    }
}
