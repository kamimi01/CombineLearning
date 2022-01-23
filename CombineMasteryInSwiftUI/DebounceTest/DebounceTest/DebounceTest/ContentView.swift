//
//  ContentView.swift
//  DebounceTest
//
//  Created by Mika Urakawa on 2022/01/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            TextField("name", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Text("結果：\(viewModel.nameEntered)")
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
