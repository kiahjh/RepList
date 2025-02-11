import SwiftUI

struct PieceView: View {
  let piece: Piece

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(self.piece.title)
          .font(.system(size: 18, weight: .semibold))
        if let composer = self.piece.composer {
          Text("by \(composer)")
            .font(.system(size: 14, weight: .regular))
            .italic()
            .foregroundStyle(.black.opacity(0.6))
        }
      }
      Spacer()
      if self.piece.familiarity == .todo {
        Image(systemName: "circle.dashed")
          .font(.system(size: 16, weight: .medium))
          .foregroundStyle(.black.opacity(0.2))
      } else {
        Image(self.familiarityIcon(self.piece.familiarity))
          .resizable()
          .frame(width: 24, height: 18)
      }
    }
    .padding(.leading, 12)
    .padding(.trailing, 16)
    .padding(.vertical, 8)
    .background(.white)
    .cornerRadius(10)
    .shadow(color: .b600.opacity(0.2), radius: 12)
  }

  init(_ piece: Piece) {
    self.piece = piece
  }

  func familiarityIcon(_ familiarity: FamiliarityLevel) -> String {
    switch familiarity {
    case .learning:
      "Learning"
    case .playable:

      "Playable"
    case .good:
      "Good"
    case .mastered:
      "Mastered"
    default:
      ""  // this shouldn't happen
    }
  }
}
