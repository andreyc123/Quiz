//
//  TestsView.swift
//  Quiz
//

import SwiftUI

struct TestsView: View {
    @StateObject var viewModel: TestsViewModel
    @State private var isTestShowing = false
    @State private var selectedTestId: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient
                    .mainAppBackground
                    .ignoresSafeArea()
                
                if case .undefined = viewModel.state {
                } else if case .progressIndicator = viewModel.state {
                    ProgressView()
                } else {
                    List {
                        ForEach(viewModel.tests) { test in
                            TestCellView(test: test) {
                                selectedTestId = test.id
                                isTestShowing = true
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tests")
            .navigationBarHidden(false)
            .onAppear {
                viewModel.getTests()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
            .errorAlert(isPresented: $viewModel.alert, message: viewModel.state.errorMessage ?? "")
            .background {
                NavigationLink(destination: TestView(viewModel: TestViewModel(testId: selectedTestId ?? "", apiClient: FirebaseApiClient.shared), isTestShowing: $isTestShowing), isActive: $isTestShowing) {
                    EmptyView()
                }
            }
        }
    }
    
    init(viewModel: TestsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

struct TestsView_Previews: PreviewProvider {
    static let viewModel: TestsViewModel = {
        let viewModel = TestsViewModel()
        viewModel.state = .success
        viewModel.tests = Test.mock
        return viewModel
    }()
    
    static var previews: some View {
        TestsView(viewModel: viewModel)
    }
}
