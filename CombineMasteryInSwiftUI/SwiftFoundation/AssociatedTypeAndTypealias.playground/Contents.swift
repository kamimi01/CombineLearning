import SwiftUI
import PlaygroundSupport

protocol GameScore {
    associatedtype TeamScore
    
    func calculateWinner(teamOne: TeamScore, teamTwo: TeamScore) -> String
}

struct FootballGame: GameScore {
    typealias TeamScore = Int
    
    func calculateWinner(teamOne: TeamScore, teamTwo: TeamScore) -> String {
        if teamOne > teamTwo {
            return "Team one wins"
        } else if teamOne == teamTwo {
            return "The teams tied."
        }
        return "Team two wins"
    }
}

struct AssociatedType_Intro: View {
    var game = FootballGame()
    private var team1 = Int.random(in: 1..<50)
    private var team2 = Int.random(in: 1..<50)
    @State private var winner = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("AssociatedType")
            
            HStack(spacing: 40) {
                Text("Team One: \(team1)")
                Text("Team Two: \(team2)")
            }
            
            Button("Calculate winner") {
                winner = game.calculateWinner(teamOne: team1, teamTwo: team2)
            }
            
            Text(winner)
            
            Spacer()
        }
        .font(.title)
    }
}

PlaygroundPage.current.setLiveView(AssociatedType_Intro())
