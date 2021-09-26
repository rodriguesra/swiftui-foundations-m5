//
//  FirebaseLoader.swift
//  Learning
//
//  Created by Rafael Rodrigues on 26/09/21.
//

import Foundation
import Firebase

class FirebaseLoader {
    
    let downloadUrl = "https://rodriguesra.github.io/learningapp-data/data2.json"
    
    // Stores the information for every module
    var modules = [Module]()
    
    init() {
        
        getRemoteData()
        getLocalData()
        
    }
    
    // MARK: Data retrieval
    
    // Retrieves JSON and style information from the remotely provided files
    func getRemoteData() {
        
        // Create the url object
        var url = URL(string: downloadUrl)
        url?.appendPathComponent("data.json")
        
        // Return if we could not get the URL
        guard url != nil else {
            print("Invalid URL")
            return
        }
        
        // Get a URL session and create a data task
        let session = URLSession.shared
        
        // Create a new data task to retrieve the json data
        let jsonRetrieve = session.dataTask(with: url!) { (data, response, error) in
            
            // Parse JSON there is no error and data was returned
            if error == nil && data != nil {
                
                do {
                    // Parse JSON into array
                    let modules = try JSONDecoder().decode([Module].self, from: data!)
                    
                    self.pushToFirebase(modules: modules)
                    
                    
                } catch let failure {
                    print("Could not parse JSON: \(failure)")
                }
                
            }
        }
        
        // Kick off the data task
        jsonRetrieve.resume()
    }
    
    // Retrieves JSON and style information from the locally provided files
    func getLocalData() {
        
        // Get file url for local json file
        let localUrl = Bundle.main.url(forResource: "data", withExtension: "json")!
        
        do {
            // Get the json data
            let data = try Data(contentsOf: localUrl)
            
            // Parse the json data into an array of modules
            let modules = try JSONDecoder().decode([Module].self, from: data)
            
            // Update the model
            pushToFirebase(modules: modules)
            
        } catch {
            
            print("Couldn't parse local json")
        }
    }
    
    func pushToFirebase(modules: [Module]) {
        
        let db = Firestore.firestore()
        
        let cloudModules = db.collection("modules")
        
        for module in modules {
            
            let content = module.content
            let test = module.test
            
            // Add the module
            let cloudModule = cloudModules.addDocument(data: [
                "category": module.category
            ])
            
            cloudModule.updateData([
                "id": cloudModule.documentID,
                "content": [
                    "image": content.image,
                    "time": content.time,
                    "description": content.description,
                    "count": content.lessons.count,
                    "id": cloudModule.documentID
                ],
                "test": [
                    "image": test.image,
                    "time": test.time,
                    "description": test.description,
                    "count": test.questions.count,
                    "id": cloudModule.documentID
                ]
            ])
            
            // Add the lessons
            for lesson in content.lessons {
                let cloudLesson = cloudModule.collection("lessons").addDocument(data: [
                    "title": lesson.title,
                    "video": lesson.video,
                    "duration": lesson.duration,
                    "explanation": lesson.explanation
                ])
                
                cloudLesson.updateData(["id": cloudLesson.documentID])
            }
            
            // Add the questions
            for question in test.questions {
                let cloudQuestion = cloudModule.collection("questions").addDocument(data: [
                    "content": question.content,
                    "correctIndex": question.correctIndex,
                    "answers": question.answers
                ])
                
                cloudQuestion.updateData(["id": cloudQuestion.documentID])
            }
            
        }
        
    }
    
}
