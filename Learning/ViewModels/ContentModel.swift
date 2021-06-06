//
//  ContentModel.swift
//  Learning
//
//  Created by Rafael Rodrigues on 03/06/21.
//

import Foundation

class ContentModel: ObservableObject {
    
    // List of modules
    @Published var modules = [Module]()
    
    // Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Current question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // Current lesson explanation
    @Published var codeText = NSAttributedString()
    var styleData: Data?
    
    // Current selected content and test
    @Published var currentContentSelected: Int?
    @Published var currentTestSelected: Int?
    
    init() {
        
        // Parse local included json data
        getLocalData()
        
        // Download remote json file and parse data
        getRemoteData()
        
    }
    
    // MARK: Data methods
    
    func getLocalData() {
        
        // Get a url to the json file
        let jsonURL = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            // Read the file into a data object
            let jsonData = try Data(contentsOf: jsonURL!)
            
            // Try to decode the json into an array of modules
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            // Assign parsed modules to modules property
            self.modules = modules
            
        }
        catch {
            // TODO log error
            print("Couldn't parse local json data")
        }
        
        // Parse the style data
        let styleURL = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            
            // Read the file into a data object
            let styleData = try Data(contentsOf: styleURL!)
            
            self.styleData = styleData
        }
        catch {
            // Log error
            print("Couldn't parse style data")
            
        }
    }
    
    func getRemoteData() {
        
        // String path
        let urlString = "https://rodriguesra.github.io/learningapp-data/data2.json"
        
        // Create a url object
        let url = URL(string: urlString)
        
        guard url != nil else {
            
            // Couldn't create url
            return
        }
        
        // Create a URLRequest object
        let request = URLRequest(url: url!)
        
        // Get the session and run the task
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            // Check if there is an error
            guard error == nil else {
                
                // There was an error
                return
            }
            
            do {
                
                // Try to decode the json into an array of modules
                let jsonDecoder = JSONDecoder()
                let modules = try jsonDecoder.decode([Module].self, from: data!)
                
                DispatchQueue.main.async {
                    // Append parser modules into modules property
                    self.modules += modules
                }
            }
            catch {
                
                // Couldn't parse json
                print("Couldn't parse remote json data")
                
            }
        }
        
        // Run the data task
        dataTask.resume()
        
    }
    
    // MARK: Module navigation methods
    
    func beginModule(_ moduleIndex: Int) {
        
        // Find the index for this module id
        for index in 0..<modules.count {
            if modules[index].id == moduleIndex {
                currentModuleIndex = index
                break
            }
        }
        
        // Set the current module
        currentModule = modules[currentModuleIndex]
        
    }
    
    // MARK: Lesson navigation methods
    
    func beginLesson(_ lessonIndex: Int) {
        
        // Check if the lesson index is within range of module lessons
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }
        else {
            currentLessonIndex = 0
        }
        
        // Set the current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
    }
    
    func nextLesson() {
        
        // Advance the lesson
        currentLessonIndex += 1
        
        // Check if it is within range
        if currentLessonIndex < currentModule!.content.lessons.count {
            
            // Set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
        }
        else {
            
            // Reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
            
            
        }
    }
    
    func hasNextLesson() -> Bool {
        
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
        
    }
    
    func beginTest(_ moduleIndex: Int) {
        
        // Set the current module
        beginModule(moduleIndex)
        
        // Set the current question index
        currentQuestionIndex = 0
        
        // If there are questions, set the current question to the first one
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            
            // Set the question content
            codeText = addStyling(currentQuestion!.content)
        }
    }
    
    func nextQuestion() {
        
        // Advance the question index
        currentQuestionIndex += 1
        
        // Check if it's within the range of questions
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
    
    // MARK: Code styling
    
    private func addStyling(_ htmlString: String) -> NSAttributedString {
    
        var resultString = NSAttributedString()
        var data = Data()
        
        // Add the styling data
        
        if styleData != nil {
            data.append(styleData!)
        }
        
        // Add the html data
        data.append(Data(htmlString.utf8))
        
        // Convert to attributed string
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            
            resultString = attributedString
        }
        
        return resultString
    }
}
