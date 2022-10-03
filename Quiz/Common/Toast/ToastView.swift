//
//  ToastView.swift
//  Quiz
//

import SwiftUI

enum ToastType {
    case info
    case success
    case failure
    
    var backgroundColor: Color {
        switch self {
        case .info:
            return .from(hex: "eeeeee")
        case .success:
            return .defaultGreen
        case .failure:
            return .red
        }
    }
    
    var titleColor: Color {
        switch self {
        case .info:
            return .black.opacity(0.7)
        case .success, .failure:
            return .white
        }
    }
}

struct ToastData: Equatable {
    let type: ToastType
    let message: String
    let duration: Double
    
    init(type: ToastType = .info, message: String, duration: Double = 1.5) {
        self.type = type
        self.message = message
        self.duration = duration
    }
    
    static func info(_ message: String) -> ToastData {
        ToastData(message: message)
    }
}

struct ToastView: View {
    let data: ToastData
    
    var body: some View {
        Text(data.message)
            .foregroundColor(data.type.titleColor)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(data.type.backgroundColor)
                    .shadow(color: Color.black.opacity(0.15),
                            radius: 3.0, x: 3, y: 3)
            )
    }
}

struct ToastModifier: ViewModifier {
    @Binding var data: ToastData?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                        .onTapGesture {
                            dismissToast()
                        }
                        .padding()
                }.animation(.spring(), value: data)
            )
            .onChange(of: data) { value in
                showToast()
            }
    }
    
    @ViewBuilder func mainToastView() -> some View {
        if let data = data {
            VStack {
                ToastView(data: data)
                
                Spacer()
            }
            .transition(.move(edge: .top))
        }
    }
    
    private func showToast() {
        guard let data = data else {
            return
        }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        if data.duration > 0 {
            workItem?.cancel()

            let task = DispatchWorkItem {
               dismissToast()
            }

            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + data.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            data = nil
        }

        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    func toastView(data: Binding<ToastData?>) -> some View {
        self.modifier(ToastModifier(data: data))
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(data: ToastData(type: .success, message: "Test message")).padding()
    }
}
