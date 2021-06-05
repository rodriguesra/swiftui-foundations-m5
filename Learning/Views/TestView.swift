//
//  TestView.swift
//  Learning
//
//  Created by Rafael Rodrigues on 04/06/21.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var selectedAnswerIndex = -1
    
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
                            
                            RectangleCard(color: .white)
                                .frame(height: 48)
                            
                            Button(action: {
                                // TODO
                            }, label: {
                                Text(model.currentQuestion!.answers[index])
                            })
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
                
                // Button
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
