//
//  ContentModel.swift
//  Learning App
//
//  Created by Jhonatan Sidrônio on 19/06/23.
//

import Foundation

class ContentModel: ObservableObject {
    
    // List of modules
    @Published var modules = [Module]() // Initialize with a empty array of Modules.
    
    
    // Keep track of selected module through this ViewModel
    /*
     Whe are established that our view model is going to keep in track of all of state, wich module the users is currently on, wich lesson their  viewing, so on and so forth. This is going make easier for the user to transition from lesson to lesson without forcing them to go back up to the lesson list in order to select the next one.
     */
    // Current module property
    @Published var currentModule:Module?
    // Keep track of a current module index we're looking at
    var currentModuleIndex = 0
    
    // Current Lesson
    @Published var currentLesson:Lesson?
    var currentLessonIndex = 0
    
    // Current Question
    @Published var currentQuestion:Question?
    var currentQuestionIndex = 0
    
    // Current lesson explanation
    @Published var codeText = NSAttributedString() // Is necessary update this property were we set the current lesson (func nextLesson())
    // Creating a optional property of the style.html to use later when parsing if we need.
    var styleData:Data?
    
    // Current selected content and test
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int? // After concluded the questions, when hit the "done", take the user back to beginning
    
    
    
    init() {
        
        // Both of these methods below are going to append and parse the data into the modules property, wich is a published property. So whenever new data gets added into this array, any view code that depends on this, like our HomeView for example, it's going to get notified and we're going to see those modules pop up.
        
        // Parse local included JSON data
        getLocalData()
        
        // Download remote JSON file and parse data
        getRemoteData()
    }
    
    // MARK: - Data Methods
    
    func getLocalData() {
        
        // Get a URL to the JSON file
        let jsonUr1 = Bundle.main.url (forResource: "data", withExtension: "json")
        
        do {
            // Read the file into a data object
            let jsonData = try Data(contentsOf: jsonUr1!)
            
            // Try to decode the JSON into an array of modules
            // Calling the decode method on a JSONDecoder() will sometimes throw and error if the JSON does not match the model you are trying to parse into. Make sure to handle the error appropriately, such as using a do, catch block!
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
    
    func getRemoteData() {
        
        // String path
        let urlString = "https://siddronio.github.io/learningapp-data/data2.json"
        
        // Create a url object (not local)
        let url = URL(string: urlString)
        
        guard url != nil else {
            // Couldn't create a url
            return
        }
        
        // Create a URLRequest object
        // Force unwrap because we checked above with the guard
        let request = URLRequest(url: url!)
        
        // With the request above, we can the use something called URL Session to kick off that request and also provide some code to run when that request returns with the data.
        
        // Get the session and kick off the task
        // This class URLSession coordinates network related tasks and we don't need to create a new instance of this class, because there is a property which returns a singleton session object (.shared). We can use the URLSession to fire off requests and work with any response such as returned JSONs.
        let session = URLSession.shared
        
        // We're going to use this dataTask where we can pass in the URL request to fire off and the we also can specify what happens when it comes back
        // Remember that class URLSession returns a URLSessionDataTask type, to keep track on that, we need to create a constant (let dataTask)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            // The code below, until the catch, is what we do in response to the requests coming back
            // Check if there's an error
            guard error == nil else {
                // There was an error
                return
            }
            
            do {
                // Handle the response
                // Create a JSON decoder
                let decoder = JSONDecoder()
                
                // Decode
                // The JSON data is inside the parameter "data" on dataTask
                // Force unwrap because we checked above with the guard error
                let modules = try decoder.decode([Module].self, from: data!)
                
                // Append parsed modules into modules property. We're append into the array instead of overwriting because the remote data, getRemoteData(), gets called after the getLocalData()
                self.modules += modules
            }
            catch {
                print("Couldn't parse JSON")
            }
            
        }
        
        // Kick off the data task
        dataTask.resume()
        
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
        
        // Set the current module property
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
        // lessonDescription = currentLesson?.explanation - We need to turn this HTML string into an attributed string, so we create a helper function (addStyling), check on the Mark: Code Styling
        codeText = addStyling(currentLesson!.explanation)
    }
    
    func nextLesson() {
        
        // Advance the lesson index
        currentLessonIndex += 1
        
        // Check that it is within range
        if currentLessonIndex < currentModule!.content.lessons.count {
            
            // Set the current lesson property and explanation
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
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
    
    func beginTest(_ moduleId:Int) {
        
        // Set the current module
        beginModule(moduleId)
        
        // Set the current question index
        currentQuestionIndex = 0
        
        // If there are questions, set the current question to the first one
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule?.test.questions[currentQuestionIndex]
            
            // Set the question content
            codeText = addStyling(currentQuestion!.content)
        }
    }
    
    func nextQuestion() {
        
        // Advance the question index
        currentQuestionIndex += 1
        
        // Check that it's within the range of questions
        if currentQuestionIndex < currentModule!.test.questions.count {
            
            // Set the current question
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
        else {
            // If not, then reset the properties
            currentQuestionIndex = 0
            currentQuestion = nil
        }
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
