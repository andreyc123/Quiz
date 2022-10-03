//
//  StatisticsView.swift
//  Quiz
//

import SwiftUI

struct StatisticsView: View {
    @Binding var isTestShowing: Bool
    @StateObject var viewModel: StatisticsViewModel
    
    private var infoView: some View {
        VStack {
            VStack {
                Text(viewModel.user.fullName)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.top, 9.0)
                    .padding(.bottom, 10.0)
                
                Image(systemName: "trophy.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40.0, height: 40.0)
                    .foregroundColor(Color.orange)
                
                Rectangle()
                    .fill(Color.defaultGray)
                    .frame(height: 1)
                    .padding(.top, 20.0)
                    .padding(.bottom, 10.0)
                
                AnswersCountView(isCorrect: true, count: viewModel.numberOfCorrectAnswers)
                
                AnswersCountView(isCorrect: false, count: viewModel.numberOfIncorrectAnswers)
                    .padding(.bottom, 15.0)
            }
            .padding()
            .frame(maxWidth: CGFloat.infinity)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .shadow(color: .black.opacity(0.15),
                    radius: 10.0, x: 0, y: 6).padding(.bottom, 15.0)
            
            ButtonView(title: "OK") {
                isTestShowing = false
            }
        }.padding(.horizontal, 35.0)
    }
    
    var body: some View {
        ZStack {
            LinearGradient.defaultAppBackground
                .ignoresSafeArea()
            
            if case .progressIndicator = viewModel.state {
                ProgressView()
            } else if case .success = viewModel.state {
                infoView
            }
        }
        .onAppear {
            viewModel.getProfile()
        }
        .errorAlert(isPresented: $viewModel.alert, message: viewModel.state.errorMessage ?? "")
        .navigationBarHidden(true)
    }
    
    init(isTestShowing: Binding<Bool>, viewModel: StatisticsViewModel) {
        _isTestShowing = isTestShowing
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(isTestShowing: .constant(true), viewModel: StatisticsViewModel(totalNumberOfQuestions: 10, numberOfCorrectAnswers: 4, apiClient: FirebaseApiClient.shared))
    }
}
