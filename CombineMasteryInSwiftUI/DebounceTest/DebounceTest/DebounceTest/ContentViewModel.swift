//
//  ContentViewModel.swift
//  DebounceTest
//
//  Created by Mika Urakawa on 2022/01/23.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var name = ""
    @Published var nameEntered = ""
    
    init() {
        $name
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .print(nameEntered)
            .assign(to: &$nameEntered)
    }
}
