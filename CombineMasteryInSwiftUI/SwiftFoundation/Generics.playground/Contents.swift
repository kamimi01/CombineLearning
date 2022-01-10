import SwiftUI
import PlaygroundSupport

struct Generics_Intro: View {
    @State private var useInt = false
    @State private var ageText = ""
    
    func getAgeText<T>(value1: T) -> String {
        return String("Age is \(value1)")
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Generics")
            
            Group {
                Toggle("Use Int", isOn: $useInt)
                Button("Show Age") {
                    if useInt {
                        ageText = getAgeText(value1: 28)
                    } else {
                        ageText = getAgeText(value1: "28")
                    }
                }
                Text(ageText)
            }
            .padding(.horizontal)
        }
        .font(.title)
    }
}

// ----------- Multiple Generics -----------------

struct Generics_Multiple: View {
    class MyGenericClass<T, U> {
        var property1: T
        var property2: U
        
        init(property1: T, property2: U) {
            self.property1 = property1
            self.property2 = property2
        }
    }
    
    var body: some View {
        let myGenericWithString = MyGenericClass(property1: "Joe", property2: "Smith")
        let myGenericWithIntAndBoolean = MyGenericClass(property1: 100, property2: true)
        
        VStack(spacing: 20) {
            Text("Generics")
            
            Text("\(myGenericWithString.property1) \(myGenericWithString.property2)")
            Text("\(myGenericWithIntAndBoolean.property1) \(myGenericWithIntAndBoolean.property2.description)")
        }
        .font(.title)
    }
}

PlaygroundPage.current.setLiveView(Generics_Intro())
