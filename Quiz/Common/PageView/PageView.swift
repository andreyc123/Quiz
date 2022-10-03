//
//  PageView.swift
//  Quiz
//

import SwiftUI

struct PageView<Page: View>: View {
    var pages: [Page]
    @Binding var currentPage: Int
    
    var body: some View {
        PageViewController(pages: pages, currentPage: $currentPage)
    }
}

struct PageView_Previews: PreviewProvider {
    static func makePage(n: Int) -> some View {
        ZStack {
            Color.red

            Text("Page \(n)")
        }
    }
    
    static var previews: some View {
        PageView(pages: [makePage(n: 1), makePage(n: 2), makePage(n: 3)], currentPage: .constant(0))
    }
}
