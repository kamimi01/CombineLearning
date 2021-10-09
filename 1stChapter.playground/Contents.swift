// オブジェクトからオブジェクトにイベントを伝える仕組みを提供する
import Combine

// PassthroughSubjectクラスは、イベントを伝える手段
// subjectはイベントを中継する役目を持つ
// Neverはエラーが発生しないことを意味する特別な指定
let subject = PassthroughSubject<String, Never>()

subject
    // sinkは、subjectでイベントを受信した際に実行する処理を指定
    // エラーが発生しない場合でのみ使用可能
    .sink { value in
        print("Received Value:", value)
    }

// sendは、subjectでString型の値を送信
subject.send("あ")
subject.send("い")
subject.send("う")
subject.send("え")
subject.send("お")

// ----------------------------------------------

let subject2 = PassthroughSubject<Int, Never>()

subject2
    .sink { value in
        let newValue = value + 2
        print("Received value:", newValue)
    }

subject2.send(1)
subject2.send(2)
subject2.send(3)

// ----------------------------------------------

let subject3 = PassthroughSubject<String, Never>()

// sinkでは、2つのクロージャーを指定
// receiveValueは、イベントを受信した際に実行する処理
// receiveCompletionはイベント完了を受信した際に実行する処理
subject3
    .sink(receiveCompletion: { completion in
        print("Received completion:", completion)
    }, receiveValue: { value in
        print("Received value:", value)
    })

subject3.send("あ")
subject3.send("い")
subject3.send("う")
subject3.send("え")
subject3.send("お")
// 値を送信する代わりに、イベント完了を意味する.finishedを送信する
subject3.send(completion: .finished)
// イベント完了しているため、この後の値は送信しても、受信されない
subject3.send("か")
subject3.send("き")

// ----------------------------------------------

enum MyError: Error {
    case failed
}

let subject4 = PassthroughSubject<String, MyError>()

subject4
    .sink(receiveCompletion: { completion in
        print("Received completion:", completion)
    }, receiveValue: { value in
        print("Received valeu:", value)
    })

subject4.send("あ")
subject4.send("い")
subject4.send("う")
subject4.send("え")
subject4.send("お")
subject4.send(completion: .failure(.failed))
