//
//  ContentView.swift
//  Learning
//
//  Created by Rafael Rodrigues on 03/06/21.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .leading) {
                
                Text("What do you want to do today?")
                    .padding(.leading, 20.0)
                
                ScrollView {
                    
                    LazyVStack {
                        
                        ForEach(model.modules) { module in
                            
                            VStack(spacing: 20.0) {
                                
                                NavigationLink(
                                    destination: ContentView()
                                        .onAppear(perform: {
                                            model.beginModule(module.id)
                                        }),
                                    tag: module.id,
                                    selection: $model.currentContentSelected,
                                    label: {
                                        // Learning card
                                        HomeViewRow(image: module.content.image,
                                                    title: "Learn \(module.category)",
                                                    description: module.content.description,
                                                    count: "\(module.content.lessons.count) lessons",
                                                    time: module.content.time)
                                    })

                                NavigationLink(
                                    destination: TestView()
                                        .onAppear(perform: {
                                            model.beginTest(module.id)
                                        }),
                                    tag: module.id,
                                    selection: $model.currentTestSelected,
                                    label: {
                                        
                                        // Test card
                                        HomeViewRow(image: module.test.image,
                                                    title: "\(module.category) Test",
                                                    description: module.test.description,
                                                    count: "\(module.test.questions.count) lessons",
                                                    time: module.test.time)
                                        
                                    })
                            }
                            .padding(.bottom, 10)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Get Started")
//            .onChange(of: model.currentContentSelected) { changedValue in
//                if changedValue == nil {
//                    model.currentModule = nil
//                }
//            }
//            onChange(of: model.currentTestSelected) { changedValue in
//                if changedValue == nil {
//                    model.currentModule = nil
//                }
//            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
