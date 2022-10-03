//
//  SignedInUserView.swift
//  Quiz
//

import SwiftUI

struct SignedInUserView: View {
    var body: some View {
        TabView {
            TestsView(viewModel: TestsViewModel())
                .tabItem {
                    Label("Tests", systemImage: "square.and.pencil")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct LoggedInUserView_Previews: PreviewProvider {
    static var previews: some View {
        SignedInUserView()
    }
}
