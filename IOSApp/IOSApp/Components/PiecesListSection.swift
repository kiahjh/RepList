import SwiftUI

struct PiecesListSection: View {
  let heading: String
  let pieces: [LearnedPiece]
  let isCollapsed: Bool
  let namespace: Namespace.ID
  let onPieceTap: (LearnedPiece) -> Void
  var onCollapse: () -> Void

  init(
    heading: String,
    pieces: [LearnedPiece],
    isCollapsed: Bool,
    namespace: Namespace.ID,
    onPieceTap: @escaping (LearnedPiece) -> Void,
    onCollapse: @escaping () -> Void
  ) {
    self.heading = heading
    self.pieces = pieces
    self.isCollapsed = isCollapsed
    self.namespace = namespace
    self.onPieceTap = onPieceTap
    self.onCollapse = onCollapse
  }

  var body: some View {
    if !self.pieces.isEmpty {
      VStack(alignment: .leading, spacing: 0) {
        Button {
          withAnimation(.smooth(duration: 0.3)) {
            self.onCollapse()
          }
        } label: {
          HStack {
            Text(self.heading)
              .font(.system(size: 16, weight: .medium))
              .foregroundStyle(.b600.opacity(0.8))
            Image(systemName: "chevron.right")
              .font(.system(size: 12, weight: .medium))
              .foregroundStyle(.b600.opacity(0.8))
              .rotationEffect(.degrees(self.isCollapsed ? 0 : 90))
            Spacer()
          }
        }
        .padding(.leading, 12)

        VStack {
          ForEach(self.pieces) { piece in
            Button {
              self.onPieceTap(piece)
            } label: {
              PieceView(
                title: piece.title, composer: piece.composer, familiarity: piece.familiarity
              )
              .matchedTransitionSource(id: piece.id, in: self.namespace)
              .shadow(color: .b600.opacity(0.2), radius: 12)
            }
          }
        }
        .padding(.top, 10)
        .frame(height: self.isCollapsed ? 0 : nil)
        .offset(y: self.isCollapsed ? Double(self.pieces.count * 35) : 0)
        .opacity(self.isCollapsed ? 0 : 1)
      }
      .padding(.top, 10)
      .padding(.horizontal, self.isCollapsed ? 0 : 16)
      .padding(.bottom, self.isCollapsed ? 10 : 20)
      .background(.b100.opacity(self.isCollapsed ? 0.5 : 0))
      .cornerRadius(12)
      .padding(.horizontal, self.isCollapsed ? 16 : 0)
      .padding(.bottom, self.isCollapsed ? 20 : 10)
    }
  }
}

