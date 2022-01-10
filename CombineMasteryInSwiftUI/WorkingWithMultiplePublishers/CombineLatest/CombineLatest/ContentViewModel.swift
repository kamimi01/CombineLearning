//
//  ContentViewModel.swift
//  CombineLatest
//
//  Created by Mika Urakawa on 2021/10/09.
//

import Foundation
import Combine

struct ContentData {
    var id = UUID()
    var name = ""
    var age = ""
    var hobby = ""
}

class ContentViewModel: ObservableObject {
    @Published var testData = ContentData() {
        didSet {
            isEnableSaveButton = true
        }
    }
    @Published var isEnableSaveButton = false
    @Published var nameInput = "名前"
    @Published var ageInput = ""
    @Published var hobbyInput = "名前2"
    @Published var optionList = ["テスト1", "テスト2", "テスト3"]
    @Published var optionList2 = ["テストa", "テストb", "テストc"]
    
    init() {
        let optionList3 = ["テストa", "テストc"]
        let optionList4 = ["テストd", "テストe"]
        $nameInput
            .map{ $0 == "テストd" ? optionList3 : optionList4}
            .assign(to: &$optionList2)
    }
    
    func onAppear() {
        // APIからデータを取得
        testData = ContentData(name: "佐藤花子",
                               age: "20",
                               hobby: "女性")
        
        //        $nameInput
        //            .map { $0 != self.testData.name ? true : false }
        //            .assign(to: &$isEnableSaveButton)
        //
        //        $ageInput
        //            .map { $0 != self.testData.age ? true : false }
        //            .assign(to: &$isEnableSaveButton)
        //
        //        $hobbyInput
        //            .map { $0 != self.testData.hobby ? true : false }
        //            .assign(to: &$isEnableSaveButton)
    }
}
