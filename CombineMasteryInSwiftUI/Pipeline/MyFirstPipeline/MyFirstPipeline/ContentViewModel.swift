//
//  ContentViewModel.swift
//  MyFirstPipeline
//
//  Created by Mika Urakawa on 2021/10/09.
//

import Combine

class ContentViewModel: ObservableObject {
    @Published var name = ""
    var nameAfter = "Test"
    @Published var validation = ""
    @Published var isEnableButton = false
    
    init() {
        name = nameAfter
        
        $name
            .map { $0.isEmpty ? "❌" : "⭕️" }
            .assign(to: &$validation)

        $name
            .map { $0 != self.nameAfter && !$0.isEmpty ? true : false }
            .assign(to: &$isEnableButton)
    }
}
