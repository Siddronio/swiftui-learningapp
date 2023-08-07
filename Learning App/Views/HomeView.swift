//
//  HomeView.swift
//  Learning App
//
//  Created by Jhonatan Sidrônio on 19/06/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model:ContentModel
    
    var body: some View {
        
        NavigationView {
            VStack (alignment: .leading) {
                Text("What do you want to do today?")
                    .padding(.leading, 20)
                
                ScrollView {
                    
                    LazyVStack {
                        
                        ForEach(model.modules) { module in
                            
                            VStack (spacing: 20) {
                                
                                /*
                                 Essentialy, when the user taps in the card, it's going to go to ContentView and the it's going to run the method beginModule, that is going to essentialy set the current module property (@Published var currentModule:Module?) and we need to reference the ContentModel inside the ContentView.)
                                 */
                                
                                NavigationLink(
                                    destination:
                                        ContentView()
                                        .onAppear(perform: {
                                            model.beginModule(module.id)
                                        }),
                                    // You can add tags and selection parameters to your NavigationLink to track what navigation the user is on.
                                    tag: module.id,
                                    selection: $model.currentContentSelected) {
                                        // Learning Card
                                        HomeViewRow(
                                            image: module.content.image,
                                            title: "Learn \(module.category)",
                                            description: module.content.description,
                                            count: "\(module.content.lessons.count) Lessons",
                                            time: module.content.time
                                        )
                                    }
                                
                                NavigationLink(
                                    destination:
                                        TestView()
                                        .onAppear(perform: {
                                            model.beginTest(module.id)
                                        }),
                                    tag: module.id,
                                    selection: $model.currentTestSelected) {
                                        // Test Card
                                        HomeViewRow(
                                            image: module.test.image,
                                            title: "\(module.category) Test",
                                            description: module.test.description,
                                            count: "\(module.test.questions.count) Lessons",
                                            time: module.test.time
                                        )
                                    }
                            }
                            .padding(.bottom, 10)
                        }
                    }
                    .accentColor(.black)
                    .padding()

                }
            }
            .navigationTitle("Get Started")
        }
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
