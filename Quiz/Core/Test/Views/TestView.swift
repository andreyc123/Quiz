//
//  TestView.swift
//  Quiz
//

import SwiftUI

struct TestView: View {
    @StateObject var viewModel: TestViewModel
    @Binding var isTestShowing: Bool
    
    private var headerView: some View {
        HStack {
            CustomBackButton(color: .black) {
                isTestShowing = false
            }
            
            Spacer()
            
            Text(viewModel.responsesPercentage.asPercentString)
                .font(.title)
                .foregroundColor(.black)
                .padding(.trailing, 15.0)
        }
        .padding(.top, 4)
        .background(
            Text("\(viewModel.currentStep)/\(viewModel.questions.count)")
                .font(.title)
                .foregroundColor(.black)
        )
    }
    
    private var pageView: some View {
        let pages = viewModel.questions.map {
            QuestionView(viewModel: $0) {
                viewModel.update()
            }
        }
        return PageView(pages: pages, currentPage: $viewModel.currentQuestionIndex)
    }
    
    var body: some View {
        ZStack {
            LinearGradient
                .mainAppBackground
                .ignoresSafeArea()
            
            if case .progressIndicator = viewModel.state {
                ProgressView()
            } else {
                VStack {
                    headerView
                    
                    if !viewModel.questions.isEmpty {
                        ZStack(alignment: .bottom) {
                            pageView
                                .padding(.bottom, 105)
                            
                            QuestionPickerView(questions: viewModel.questions, selectedIndex: $viewModel.currentQuestionIndex)
                        }
                    } else {
                        Spacer()
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.getTestQuestions()
        }
        .errorAlert(isPresented: $viewModel.alert, message: viewModel.state.errorMessage ?? "")
        .background {
            let statisticsViewModel = StatisticsViewModel(totalNumberOfQuestions: viewModel.questions.count, numberOfCorrectAnswers: viewModel.numberOfCorrectAnswers, apiClient: FirebaseApiClient.shared)
            let statisticsView = StatisticsView(isTestShowing: $isTestShowing, viewModel: statisticsViewModel)
            NavigationLink(destination: statisticsView, isActive: $viewModel.isStatisticsShowing) {
                EmptyView()
            }
        }
    }
    
    init(viewModel: TestViewModel, isTestShowing: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _isTestShowing = isTestShowing
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView(viewModel: TestViewModel(testId: "", apiClient: FirebaseApiClient.shared), isTestShowing: .constant(true))
    }
}
