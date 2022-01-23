import Combine
import Foundation

let bounces:[(Int,TimeInterval)] = [
    (0, 0),
    (1, 0.25),  // 0.25s interval since last index
    (2, 1),     // 0.75s interval since last index
    (3, 1.25),  // 0.25s interval since last index
    (4, 1.5),   // 0.25s interval since last index
    (5, 2)      // 0.5s interval since last index
]

let subject = PassthroughSubject<Int, Never>()
var cancellable: AnyCancellable?

cancellable = subject
    .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
    .sink { index in
        print ("Received index \(index)")
    }

for bounce in bounces {
    DispatchQueue.main.asyncAfter(deadline: .now() + bounce.1) {
        subject.send(bounce.0)
        print("sendされた：", bounce.0)
    }
}
