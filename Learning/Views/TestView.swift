//
//  TestView.swift
//  Learning
//
//  Created by Rafael Rodrigues on 04/06/21.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @State var selectedAnswerIndex: Int?
    @State var submitted = false
    
    @State var numCorrect = 0
    
    
    var body: some View {
        
        if model.currentQuestion != nil {
            
            VStack(alignment: .leading) {
                
                // Question number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                
                // Question
                CodeTextView()
                    .padding(.horizontal, 20)
                
                // Answers
                ScrollView {
                    VStack {
                        ForEach(0..<model.currentQuestion!.answers.count, id: \.self) { index in
                            
                            Button(action: {
                                // Track the selected index
                                selectedAnswerIndex = index
                                
                            }, label: {
                                ZStack {
                                    if submitted == false {
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height: 48)
                                    }
                                    else {
                                        // Answer has been submitted
                                        if index == selectedAnswerIndex && index == model.currentQuestion!.correctIndex {
                                            
                                            // User has selected the right answer, show a green background
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        }
                                        
                                        else if index == selectedAnswerIndex && index != model.currentQuestion!.correctIndex {
                                            
                                            // User has selected the wrong answer, show a red background
                                            RectangleCard(color: .red)
                                                .frame(height: 48)
                                        }
                                        
                                        else if index == model.currentQuestion!.correctIndex {
                                            
                                            // This button is the correct answer
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        }
                                        else {
                                            RectangleCard(color: .white)
                                                .frame(height: 48)
                                        }
                                    }
                                    
                                    Text(model.currentQuestion!.answers[index])
                                    
                                }
                            })
                            .disabled(submitted)
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
                
                // Submit Button
                Button {
                    
                    // Change the submitted state to true
                    submitted = true
                    
                    // Check the answer and increment the counter if correct
                    if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                        numCorrect += 1
                    }
                    
                } label: {
                    
                    ZStack {
                        
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        
                        Text("Submit")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                }
                .disabled(selectedAnswerIndex == nil)

            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
            
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
