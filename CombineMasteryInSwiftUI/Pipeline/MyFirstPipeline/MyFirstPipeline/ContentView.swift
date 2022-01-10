//
//  ContentView.swift
//  MyFirstPipeline
//
//  Created by Mika Urakawa on 2021/10/09.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("First Pipeline")
                .font(.title)
            
            Text("Introduction")
                .foregroundColor(.gray)
                .font(.title2)
            
            Text("以前の登録値：\(viewModel.nameAfter)")
            
            HStack(spacing: 10) {
                TextField("name", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text(viewModel.validation)
            }
            .padding()
            
            Button(action: {}) {
                Text("保存")
                    .foregroundColor(viewModel.isEnableButton ? .red : .gray)
            }
            .disabled(!viewModel.isEnableButton)
        }
        .font(.title)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
