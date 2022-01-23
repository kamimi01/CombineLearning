//
//  ContentView.swift
//  DropFirstTest
//
//  Created by Mika Urakawa on 2022/01/16.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create a User ID")
            
            TextField("user id", text: $viewModel.userId)
                .padding()
                .border(statusColor)
                .padding()
        }
        .font(.title)
    }
}

private extension ContentView {
    // textfieldの入力値によって、textfieldのボーダーカラーを変更する
    private var statusColor: Color {
        switch viewModel.isUserIdValid {
        case .ok: return .green
        case .invalid: return .red
        case .notEvaluated: return .secondary
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
