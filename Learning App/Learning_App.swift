//
//  Learning_App.swift
//  Learning App
//
//  Created by Jhonatan Sidrônio on 19/06/23.
//

import SwiftUI

@main
struct Learning_App: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
