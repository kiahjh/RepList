import Foundation

extension Piece {
  static func example(
    title: String = "Si Bheag Si Mhor",
    composer: String? = "Turlough O'Carolan",
    familiarity: FamiliarityLevel = .good
  ) -> Piece {
    Piece(
      id: UUID(),
      title: title,
      familiarity: familiarity,
      composer: composer,
      createdAt: Date()
    )
  }

  static var list: [Piece] {
    [
      Piece.example(
        title: "The Boyne Water",
        composer: nil,
        familiarity: .todo
      ),
      Piece.example(
        title: "Johans vals",
        composer: "Väsen",
        familiarity: .todo
      ),
      Piece.example(
        title: "Cattle in the Cane",
        composer: nil,
        familiarity: .todo
      ),
      Piece.example(
        title: "Si Bheag Si Mhor",
        composer: "Turlough O'Carolan",
        familiarity: .learning
      ),
      Piece.example(
        title: "Red Shift",
        composer: "Matt Flinner",
        familiarity: .learning
      ),
      Piece.example(
        title: "The Magerabaun Reel",
        composer: nil,
        familiarity: .playable
      ),
      Piece.example(
        title: "August",
        composer: "Trio Dhoore",
        familiarity: .playable
      ),
      Piece.example(
        title: "Made in France",
        composer: "Bireli Lagrene",
        familiarity: .good
      ),
      Piece.example(
        title: "Krasavaska Ruchenitsa",
        composer: "Jayme Stone",
        familiarity: .good
      ),
      Piece.example(
        title: "Dorrigo",
        composer: "David Benedict",
        familiarity: .good
      ),
      Piece.example(
        title: "A Lark",
        composer: "Fred Hersch",
        familiarity: .good
      ),
      Piece.example(
        title: "Ano Bom",
        composer: "Hamilton De Holanda",
        familiarity: .mastered
      ),
      Piece.example(
        title: "Walk Along John to Kansas",
        composer: "John Reischman",
        familiarity: .mastered
      ),
      Piece.example(
        title: "From Ankara to Izmir",
        composer: nil,
        familiarity: .mastered
      ),
      Piece.example(
        title: "Big Sciota",
        composer: nil,
        familiarity: .mastered
      ),
      Piece.example(
        title: "Fish Scale",
        composer: "David Grisman",
        familiarity: .mastered
      ),
      Piece.example(
        title: "Whitewater",
        composer: "Béla Fleck",
        familiarity: .mastered
      ),
    ]
  }
}
