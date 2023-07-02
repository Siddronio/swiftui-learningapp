//
//  ContentModel.swift
//  Learning App
//
//  Created by Jhonatan Sidrônio on 19/06/23.
//

import Foundation

class ContentModel: ObservableObject {
    
    // List of modules
    @Published var modules = [Module]()
    
    
    // Keep track of selected module through this ViewModel
    /*
     Whe are established that our view model is going to keep in track of all of state, wich module the users is currently on, wich lesson their  viewing, so on and so forth. This is going make easier for the user to transition from lesson to lesson without forcing them to go back up to the lesson list in order to select the next one.
     */
    
    // Current Module
    @Published var currentModule:Module?
    
    // Keep track of a current module index
    var currentModuleIndex = 0
    
    // Current Lesson
    @Published var currentLesson:Lesson?
    var currentLessonIndex = 0
    
    // Current lesson explanation
    @Published var lessonDescription = NSAttributedString()
    
    var styleData:Data?
    
    init() {
        
        getLocalData()
    }
    
    // MARK: - Data Methods
    
    func getLocalData() {
        
        // Get a URL to the JSON file
        let jsonUr1 = Bundle.main.url (forResource: "data", withExtension: "json")
        
        do {
            // Read the file into a data object
            let jsonData = try Data(contentsOf: jsonUr1!)
            
            // Try to decode the JSON into an array of modules
            let jsonDecoder = JSONDecoder() // Calling the decode method on a JSONDecoder() will sometimes throw and error if the JSON does not match the model you are trying to parse into. Make sure to handle the error appropriately, such as using a do, catch block!
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
    
    // MARK: - Module Navigation Methods
    
    func beginModule(_ moduleId: Int) {
        
        // Find the index for this module id
        for index in 0..<modules.count {
            
            if modules[index].id == moduleId {
                
                // Found the machting module
                currentModuleIndex = index
                break
            }
        }
        
        // Set the current index
        currentModule = modules[currentModuleIndex]
        
    }
    
    func beginLesson(_ lessonIndex: Int) {
        
        // Check that the lesson index is within range of modules lesson
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }
        // If that lesson index happens to be out of range, then we're going to set the currentLessonIndex to zero.
        else {
            currentLessonIndex = 0
        }
        
        // Set the current lesson and the current explanation
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        // We need to turn this HTML string into an attributed string, so we create a helper function (addStyling)
        lessonDescription = addStyling(currentLesson!.explanation)
    }
    
    func nextLesson() {
        
        // Advance the lesson index
        currentLessonIndex += 1
        
        // Check that it is within range
        if currentLessonIndex < currentModule!.content.lessons.count {
            
            // Set the current lesson property and explanation
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            lessonDescription = addStyling(currentLesson!.explanation)
        }
        else {
            // Reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
        }
        
        
    }
    
    func hasNextLession() -> Bool {
        
        /*
         // A way to write the check
         if currentLessonIndex + 1 < currentModule!.content.lessons.count {
         return true
         }
         else {
         return false
         }
         */
        // The easier way
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
    }
    
    // MARK: - Code Styling
    
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        var data = Data()
        
        // Add the styling data
        if styleData != nil {
            data.append(styleData!)
        }
        
        // Add the HTML data
        data.append(Data(htmlString.utf8))
        
        // Convert to attributed string (https://www.hackingwithswift.com/example-code/system/how-to-convert-html-to-an-nsattributedstring)
        // Technique 1
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            
            resultString = attributedString
        }
        
        /*
         Technique 2 (If you need catch and handle the error)
         
         do {
             let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
             
             resultString = attributedString
         }
         catch {
             print("Couldn't turn html into attibuted string")
         }
         */
        
        return resultString
    }
    
}
