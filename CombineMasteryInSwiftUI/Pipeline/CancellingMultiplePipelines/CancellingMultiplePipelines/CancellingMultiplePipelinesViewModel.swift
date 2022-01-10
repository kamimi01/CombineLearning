//
//  CnacellingMultiplePipelinesViewModel.swift
//  CancellingMultiplePipelines
//
//  Created by Mika Urakawa on 2021/10/09.
//
import Foundation
import Combine

class CancellingMultiplePipelinesViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var firstNameValidation = ""
    @Published var lastNameValidation = ""
    
    private var validationCancellables: Set<AnyCancellable> = []
    
    init() {
        $firstName
            .map { $0.isEmpty ? "❌" : "⭕️" }
            .sink { [unowned self] value in
                self.firstNameValidation = value
            }
            .store(in: &validationCancellables)
        
        $lastName
            .map { $0.isEmpty ?  "❌" : "⭕️" }
            .sink { [unowned self] value in
                self.lastNameValidation = value
            }
            .store(in: &validationCancellables)
    }
    
    func cancelAllValidations() {
        validationCancellables.removeAll()
    }
}
