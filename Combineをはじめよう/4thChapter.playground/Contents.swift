import Combine
import Foundation

final class Model {
    @Published var value: String = "0"
}

let model = Model()

final class ViewModel {
    var text: String = "" {
        didSet {
            print("didSet text:", text)
        }
    }
}

final class Receiver {
    var subscriptions = Set<AnyCancellable>()
    let viewModel = ViewModel()
    
    init() {
        model.$value
            .assign(to: \.text, on: viewModel)
            .store(in: &subscriptions)
    }
}

let receiver = Receiver()

model.value = "1"
model.value = "2"
model.value = "3"
model.value = "4"
model.value = "5"


// ----------------------------------------------


final class Model2 {
    @Published var value: Int = 0
}

let model2 = Model2()

final class ViewModel2 {
    var text: String = "" {
        didSet {
            print("didSet text:", text)
        }
    }
}

final class Receiver2 {
    var subscriptions = Set<AnyCancellable>()
    let viewModel = ViewModel2()
    let formatter = NumberFormatter()
    
    init() {
        formatter.numberStyle = .spellOut
        
        model2.$value
            // Publisherを別のPublisherに変換している = Operator
            .map { value in
                // クロージャの中で、$valueがpublishしたIntの値をStringに変換
                self.formatter.string(
                    from: NSNumber(integerLiteral: value)) ?? ""
            }
            // assignには、変換後の値が渡される
            .assign(to: \.text, on: viewModel)
            .store(in: &subscriptions)
    }
}

let receiver2 = Receiver2()

model2.value = 1
model2.value = 2
model2.value = 3
model2.value = 4
model2.value = 5


// ----------------------------------------------


final class Model3 {
    @Published var value: Int = 0
}

let model3 = Model3()

final class ViewModel3 {
    var text: String = "" {
        didSet {
            print("didSet value:", text)
        }
    }
}

final class Receiver3 {
    var subscriptions = Set<AnyCancellable>()
    let viewModel = ViewModel3()
    let formatter = NumberFormatter()
    
    init() {
        formatter.numberStyle = .spellOut
        
        model3.$value
            // 条件に適合しないものは、publishしないようにする
            .filter { value in
                value % 2 == 0
            }
            .map { value in
                self.formatter.string(
                    from: NSNumber(integerLiteral: value)) ?? ""
            }
            .assign(to: \.text, on: viewModel)
            .store(in: &subscriptions)
    }
}

let receiver3 = Receiver3()

model3.value = 1
model3.value = 2
model3.value = 3
model3.value = 4
model3.value = 5

// ----------------------------------------------


final class Model4 {
    @Published var value: Int = 0
}

let model4 = Model4()

final class ViewModel4 {
    var text: String = "" {
        didSet {
            print("didSet value:", text)
        }
    }
}

final class Receiver4 {
    var subscriptions = Set<AnyCancellable>()
    let viewModel = ViewModel()
    let formatter = NumberFormatter()
    
    init() {
        formatter.numberStyle = .spellOut
        
        model4.$value
            // mapと似ているが、値がnilになった場合は、publishしない
            .compactMap { value in
                // ここでnilが返される可能性があるが、明示的に対処を書く必要がない
                // 変換後の値は、String?ではなく、Stringになる
                self.formatter.string(
                    from: NSNumber(integerLiteral: value))
            }
            .assign(to: \.text, on: viewModel)
            .store(in: &subscriptions)
    }
}

let receiver4 = Receiver4()

model4.value = 11
model4.value = 12
model4.value = 13
model4.value = 14
model4.value = 15


// ----------------------------------------------


final class Model5 {
    let subjectX = PassthroughSubject<String, Never>()
    let subjectY = PassthroughSubject<String, Never>()
}

let model5 = Model5()

final class ViewModel5 {
    var text: String = "" {
        didSet {
            print("didSet value:", text)
        }
    }
}

final class Receiver5 {
    var subscriptions = Set<AnyCancellable>()
    let viewModel = ViewModel5()
    
    init() {
        model5.subjectX
            // 2つのPublisherのうち、どちらかがPublishした場合に、両方の最新の値をタプルで組みにしてpublishする
            // 片方がまだ1つもpublishしていない場合はpublishしない
            .combineLatest(model5.subjectY)
            .map { valueX, valueY in
                "X:" + valueX + " Y:" + valueY
            }
            .assign(to: \.text, on: viewModel)
            .store(in: &subscriptions)
    }
}
