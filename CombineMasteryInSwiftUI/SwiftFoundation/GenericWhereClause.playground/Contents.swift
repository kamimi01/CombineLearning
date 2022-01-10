import SwiftUI
import PlaygroundSupport

protocol Job {
    associatedtype SkillId
    
    var id: SkillId { get set }
}

protocol Person {
    associatedtype SkillId
    var knows: SkillId { get set }
    
    mutating func assign<J>(job: J) where J: Job, Self.SkillId == J.SkillId
}

struct JobA: Job {
    typealias SkillId = Int
    
    var id: SkillId
}

struct Developer: Person {
    typealias SkillId = Int
    
    var knows: SkillId
    
    mutating func assign<J>(job: J) where J : Job, Self.SkillId == J.SkillId {
        self.knows = job.id
    }
}

struct SkillMapView: View {
    var job = JobA(id: 20)
    @State var developer = Developer(knows: 30)
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                developer.assign(job: job)
            }) {
                Text("アサインする")
            }
            
            Text("スキルは：\(developer.knows)")
        }
    }
}

PlaygroundPage.current.setLiveView(SkillMapView())
