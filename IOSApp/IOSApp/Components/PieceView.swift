import SwiftUI

struct PieceView: View {
  let title: String
  let composer: String?
  let familiarity: FamiliarityLevel?
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(self.title)
          .font(.system(size: 18, weight: .semibold))
          .foregroundStyle(.black)
        if let composer = self.composer {
          Text("by \(composer)")
            .font(.system(size: 14, weight: .regular))
            .italic()
            .foregroundStyle(.black.opacity(0.6))
        }
      }
      Spacer()
      if let familiarity = self.familiarity {
        if familiarity == .todo {
          Image(systemName: "circle.dashed")
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.black.opacity(0.2))
        } else {
          Image(self.familiarityIcon(familiarity))
            .resizable()
            .frame(width: 24, height: 18)
        }
      }
    }
    .padding(.leading, 12)
    .padding(.trailing, 16)
    .padding(.vertical, 8)
    .background(.white)
    .cornerRadius(10)
  }

  init(title: String, composer: String?, familiarity: FamiliarityLevel? = nil) {
    self.title = title
    self.composer = composer
    self.familiarity = familiarity
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
