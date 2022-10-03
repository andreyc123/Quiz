//
//  ContentView.swift
//  Quiz
//

import SwiftUI

struct ContentView: View {
    @AppStorage(.isSignedInKey) var isSignedIn = false
    
    var body: some View {
        if !isSignedIn {
            NavigationView {
                LoginView()
                    .navigationBarHidden(true)
            }
        } else {
            SignedInUserView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
