//
//  ContentViewModel.swift
//  DropFirstTest
//
//  Created by Mika Urakawa on 2022/01/16.
//

import Foundation

enum Validation {
    case ok
    case invalid
    case notEvaluated
}

class ContentViewModel: ObservableObject {
    @Published var userId = ""
    @Published var isUserIdValid = Validation.notEvaluated
    
    init() {
        // ViewModelの初期化時に、userIdに空文字が割り当てられるため、このパイプラインは実行される
        $userId
            .dropFirst()  // ここで使用されている
            .map { userId -> Validation in
                // dropFirstなしで実行された結果、空文字つまり0文字のため、.invalidとなり、
                // ユーザーは何も入力していないにもかかわらず、textfieldのボーダーカラーは赤になる
                userId.count > 8 ? .ok : .invalid
            }
            .assign(to: &$isUserIdValid)
    }
}
