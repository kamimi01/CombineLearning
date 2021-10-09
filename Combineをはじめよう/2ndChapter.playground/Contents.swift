import Combine

let subject = PassthroughSubject<String, Never>()

final class Receiver {
    let subscription: AnyCancellable
    
    init() {
        // 受信処理を有効にするには、sinkの戻り値を保持する必要がある
        // イベントの受信処理を指定すること = subscribe
        // 受信処理を指定したときの戻り値 = subscription
        // subscriptionが破棄されれば、受信処理も破棄される
        subscription = subject
            .sink { value in
                print("Received value:", value)
            }
    }
}

let receiver = Receiver()

subject.send("あ")
subject.send("い")
subject.send("う")
subject.send("え")
subject.send("お")

// ----------------------------------------------

let subject2 = PassthroughSubject<String, Never>()

final class Receiver2 {
    let subscription: AnyCancellable
    
    init() {
        subscription = subject2
            .sink { value in
                print("Received valued:", value)
            }
    }
}

let receiver2 = Receiver2()

subject2.send("あ")
subject2.send("い")
subject2.send("う")
// キャンセルされる
receiver2.subscription.cancel()
// キャンセルされると、以降の処理は実行されない
subject2.send("え")
subject2.send("お")

// ----------------------------------------------

let subject3 = PassthroughSubject<String, Never>()

final class Receiver3 {
    let subscription1: AnyCancellable
    let subscription2: AnyCancellable
    
    init() {
        // 1つのsubjectに対して、複数のsubscribe（受信処理の指定）を行うこともできる
        subscription1 = subject3
            .sink { value in
                print("[1] Received value:", value)
            }
        
        subscription2 = subject3
            .sink { value in
                print("[2] Received value:", value)
            }
    }
}

let receiver3 = Receiver3()

subject3.send("あ")
subject3.send("い")
subject3.send("う")
// subscription1のみキャンセルする
receiver3.subscription1.cancel()
subject3.send("え")
subject3.send("お")

// ----------------------------------------------

let subject4 = PassthroughSubject<String, Never>()

final class Receiver4 {
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        subject4
            .sink { value in
                print("[1] Received value:", value)
            }
            .store(in: &subscriptions)
        
        subject4
            .sink { value in
                print("[2] Received value:", value)
            }
            .store(in: &subscriptions)
    }
}

let receiver4 = Receiver4()

subject4.send("あ")
subject4.send("い")
subject4.send("う")
subject4.send("え")
subject4.send("お")

// ----------------------------------------------

let subject5 = PassthroughSubject<String, Never>()

final class SomeObject {
    var value: String = "" {
        didSet {
            print("didSet value:", value)
        }
    }
}

final class Receiver5 {
    var subscriptions = Set<AnyCancellable>()
    let object = SomeObject()
    
    init() {
        subject5
            // クロージャーではなく、オブジェクトを指定する
            // エラーが発生しないイベント（エラーの型がNever）でないと、使用できない
            .assign(to: \.value, on: object)
            .store(in: &subscriptions)
    }
}

let receiver5 = Receiver5()

subject5.send("あ")
subject5.send("い")
subject5.send("う")
subject5.send("え")
subject5.send("お")
