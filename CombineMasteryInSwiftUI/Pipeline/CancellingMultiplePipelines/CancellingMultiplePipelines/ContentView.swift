//
//  ContentView.swift
//  CancellingMultiplePipelines
//
//  Created by Mika Urakawa on 2021/10/09.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = CancellingMultiplePipelinesViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Store")
            
            Group {
                HStack {
                    TextField("first name", text: $viewModel.firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text(viewModel.firstNameValidation)
                }
                
                HStack {
                    TextField("last name", text: $viewModel.lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text(viewModel.lastNameValidation)
                }
            }
            .padding()
            
            Button("Cancel All Validations") {
                viewModel.cancelAllValidations()
            }
        }
        .font(.title)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
