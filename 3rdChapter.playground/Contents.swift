import Combine
import Foundation

// publisherをつけることで、ArrayからPublisherを生成
// イベントを送信するオブジェクト = Publisher
// イベントを送信すること = publish
// Arrayの要素を順番にpublishして、最後に.finishedをpublishする
let publisher = ["あ", "い", "う", "え", "お"].publisher
//let publisher = (1 ... 5).publisher

final class Receiver {
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        publisher
            .sink(receiveCompletion: { completion in
                print("Received completion:", completion)
            }, receiveValue: { value in
                print("Received value:", value)
            })
            .store(in: &subscriptions)
    }
}

let receiver = Receiver()

// ----------------------------------------------

// TimerクラスのstaticメソッドでPublisherを生成
// 1秒ごとに現在時刻をpublishする
let publisher2 = Timer.publish(every: 1, on: .main, in: .common)

final class Receiver2 {
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        publisher2
//            .autoconnect()  // autoconnectがあれば、subscribeしたときに自動的にconnect処理を行う
            .sink { value in
                print("Received value:", value)
            }
            .store(in: &subscriptions)
    }
}

let receiver2 = Receiver2()
// このPublisherはconnectしないと、subscribe（イベントを受信）しても、イベントをpublishしない！
publisher2.connect()

// ----------------------------------------------

let myNotification = Notification.Name("MyNotification")
// NotificationのPublisherは、指定した通知がpostされたとき、その通知をpublishする（そのイベントを送信する）
let publisher3 = NotificationCenter.default.publisher(for: myNotification)

final class Receiver3 {
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        publisher3
            .sink { value in
                print("Received value:", value)
            }
            .store(in: &subscriptions)
    }
}

let receiver3 = Receiver3()
NotificationCenter.default.post(Notification(name: myNotification))

// ----------------------------------------------

let url = URL(string: "https://www.example.com")!
let publisher4 = URLSession.shared.dataTaskPublisher(for: url)

final class Receiver4 {
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        publisher4
            .sink(receiveCompletion: { completion in
                // URLSessionのPublisherはエラーをpublishする場合がある
                // エラーの型はURLError
                if case let .failure(error) = completion {
                    print("Received error:", error)
                } else {
                    print("Received completion:", completion)
                }
            }, receiveValue: { data, response in
                // 通信に成功すれば、その結果をpublishする
                // 値の型は、(data: Data, response: URLResponse)のタプル
                print("Received data:", data)
                print("Received response:", response)
            })
            .store(in: &subscriptions)
    }
}

let receiver4 = Receiver4()

// ----------------------------------------------

// 初期化時には、初期値を与える必要がある
// CurrentValueSubjectをsubscribe（イベントを送信）すると、すぐに現在の値をsubscribeする→だからAの値が初めにprintされる
let subject5 = CurrentValueSubject<String, Never>("A")

final class Receiver5 {
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        subject5
            .sink { value in
                print("Received value:", value)
            }
            .store(in: &subscriptions)
    }
}

let receiver5 = Receiver5()

// subjectはsendメソッドを呼ぶと、publishする
subject5.send("あ")
subject5.send("い")
subject5.send("う")
subject5.send("え")
subject5.send("お")
// 現在の値を取得できる
print("Current value:", subject5.value)

// ----------------------------------------------

let subject6 = PassthroughSubject<String, Never>()
// eraseToAnyPublsherにより、Subjectが単なるPublisherになる
let publisher6 = subject6.eraseToAnyPublisher()

final class Receiver6 {
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        // subjectを使わず、publisherだけを使う
        publisher6
            .sink { value in
                print("Received value:", value)
            }
            .store(in: &subscriptions)
    }
}

let receiver6 = Receiver6()

subject6.send("あ")
subject6.send("い")
subject6.send("う")
subject6.send("え")
subject6.send("お")

// ----------------------------------------------

final class Sender {
    // @Publishedを使用することで、普通のプロパティからPublisherが生成される
    @Published var event: String = "A"
    // 以下のようにすることで、Senderクラスの外部からeventプロパティに直接setできないように制限できる
//    @Published private(set) var event: String = "A"
}

let sender = Sender()

final class Receiver7 {
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        // 元のプロパティに値がセットされると、その値をpublishする
        sender.$event
            .sink { value in
                print("Received value:", value)
            }
            .store(in: &subscriptions)
    }
}

let receiver7 = Receiver7()

sender.event = "か"
sender.event = "き"
sender.event = "く"
sender.event = "け"
sender.event = "こ"
