import ComposableArchitecture
import Foundation

extension LearnedPiece {
  static func example(
    title: String = "Si Bheag Si Mhor",
    composer: String? = "Turlough O'Carolan",
    familiarity: FamiliarityLevel = .good
  ) -> LearnedPiece {
    @Dependency(\.uuid) var uuid
    @Dependency(\.date) var date

    return LearnedPiece(
      id: uuid(),
      title: title,
      familiarity: familiarity,
      composer: composer,
      createdAt: date()
    )
  }

  static var list: [LearnedPiece] {
    return [
      LearnedPiece.example(
        title: "The Boyne Water",
        composer: nil,
        familiarity: .todo
      ),
      LearnedPiece.example(
        title: "Johans vals",
        composer: "Väsen",
        familiarity: .todo
      ),
      LearnedPiece.example(
        title: "Cattle in the Cane",
        composer: nil,
        familiarity: .todo
      ),
      LearnedPiece.example(
        title: "Si Bheag Si Mhor",
        composer: "Turlough O'Carolan",
        familiarity: .learning
      ),
      LearnedPiece.example(
        title: "Red Shift",
        composer: "Matt Flinner",
        familiarity: .learning
      ),
      LearnedPiece.example(
        title: "The Magerabaun Reel",
        composer: nil,
        familiarity: .playable
      ),
      LearnedPiece.example(
        title: "August",
        composer: "Trio Dhoore",
        familiarity: .playable
      ),
      LearnedPiece.example(
        title: "Made in France",
        composer: "Bireli Lagrene",
        familiarity: .good
      ),
      LearnedPiece.example(
        title: "Krasavaska Ruchenitsa",
        composer: "Jayme Stone",
        familiarity: .good
      ),
      LearnedPiece.example(
        title: "Dorrigo",
        composer: "David Benedict",
        familiarity: .good
      ),
      LearnedPiece.example(
        title: "A Lark",
        composer: "Fred Hersch",
        familiarity: .good
      ),
      LearnedPiece.example(
        title: "Ano Bom",
        composer: "Hamilton De Holanda",
        familiarity: .mastered
      ),
      LearnedPiece.example(
        title: "Walk Along John to Kansas",
        composer: "John Reischman",
        familiarity: .mastered
      ),
      LearnedPiece.example(
        title: "From Ankara to Izmir",
        composer: nil,
        familiarity: .mastered
      ),
      LearnedPiece.example(
        title: "Big Sciota",
        composer: nil,
        familiarity: .mastered
      ),
      LearnedPiece.example(
        title: "Fish Scale",
        composer: "David Grisman",
        familiarity: .mastered
      ),
      LearnedPiece.example(
        title: "Whitewater",
        composer: "Béla Fleck",
        familiarity: .mastered
      ),
    ]
  }
}
