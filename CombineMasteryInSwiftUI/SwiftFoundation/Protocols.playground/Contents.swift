import SwiftUI
import PlaygroundSupport

protocol PersonProtocol {
    var firstName: String { get set }
    var lastName: String { get set }
    
    func getFullName() -> String
}

struct DeveloperStruct: PersonProtocol {
    var firstName: String
    var lastName: String
    
    func getFullName() -> String {
        return firstName + " " + lastName
    }
}

struct Protocol_Intro: View {
    private var dev = DeveloperStruct(firstName: "Scott", lastName: "Ching")
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Protocol_Intro")
            
            Text("Name: \(dev.getFullName())")
        }
        .font(.title)
    }
}

// ------------------------------

class StudentClass: PersonProtocol {
    var firstName: String
    var lastName: String
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    func getFullName() -> String {
        return lastName + ", " + firstName
    }
}

struct Protocol_AsType: View {
    var developer: PersonProtocol
    var student: PersonProtocol
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Protocols")
            
            Text(developer.getFullName())
            Text(student.getFullName())
        }
        .font(.title)
    }
}

PlaygroundPage.current.setLiveView(Protocol_Intro())

PlaygroundPage.current.setLiveView(
    Protocol_AsType(
        developer: DeveloperStruct(firstName: "Chris", lastName: "Smith"),
        student: StudentClass(firstName: "Mark", lastName: "MoeyKens"))
    )
