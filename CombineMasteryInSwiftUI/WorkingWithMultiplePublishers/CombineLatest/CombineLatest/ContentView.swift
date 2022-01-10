//
//  ContentView.swift
//  CombineLatest
//
//  Created by Mika Urakawa on 2021/10/09.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = ContentViewModel()
    @State private var isShownPopover = false
    
    var body: some View {
        VStack {
            Button(action: {
                isShownPopover = true
            }) {
                Text(viewModel.nameInput)
                    .popover(isPresented: $isShownPopover) {
                        List(viewModel.optionList, id: \.self) { option in
                            Button(option) {
                                viewModel.nameInput = option
                                isShownPopover = false
                            }
                        }
                    }
            }
            
            Divider()
            
            Button(action: {
                isShownPopover = true
            }) {
                Text(viewModel.hobbyInput)
                    .popover(isPresented: $isShownPopover) {
                        List(viewModel.optionList2, id: \.self) { option in
                            Button(option) {
                                viewModel.hobbyInput = option
                                isShownPopover = false
                            }
                        }
                    }
            }

            Button("保存") {
                print("保存したよ")
            }
            .foregroundColor(viewModel.isEnableSaveButton ? .red : .gray)
            .disabled(!viewModel.isEnableSaveButton)
            
            List(viewModel.optionList, id: \.self) { option in
                Text(option)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
