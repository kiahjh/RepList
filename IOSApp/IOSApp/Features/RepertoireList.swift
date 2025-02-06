import ComposableArchitecture
import SwiftUI

@Reducer
struct RepertoireList {
  @ObservableState
  struct State {
    var pieces: [Piece]
  }

  enum Action {}

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {}
    }
  }
}

struct RepertoireListView: View {
  let store: StoreOf<RepertoireList>

  var groupedPieces: GroupedPieces {
    GroupedPieces(self.store.pieces)
  }

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      ScrollView {
        VStack(spacing: 0) {
          PiecesListSection("Currently learning", pieces: self.groupedPieces.byFamiliarity(.learning))
          PiecesListSection("Next up", pieces: self.groupedPieces.byFamiliarity(.todo))
          PiecesListSection(
            "Needing some work",
            pieces: self.groupedPieces.byFamiliarity(.playable)
          )
          PiecesListSection("Learned", pieces: self.groupedPieces.byFamiliarity([.good, .mastered]))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        .padding(.bottom, 120)
      }
      .background(.b50.opacity(0.6))

      Button {} label: {
        Image(systemName: "plus")
          .foregroundStyle(.white)
          .font(.system(size: 28, weight: .medium))
          .padding(12)
          .background(.b500)
          .cornerRadius(30)
          .padding(20)
          .shadow(color: .b700.opacity(0.3), radius: 12, x: 0, y: 8)
      }
    }
    .navigationTitle("Repertoire")
  }
}

struct PiecesListSection: View {
  let heading: String
  let pieces: [Piece]

  @State private var isExpanded = true

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Button {
        withAnimation(.smooth(duration: 0.3)) {
          self.isExpanded.toggle()
        }
      } label: {
        HStack {
          Text(self.heading)
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.b600.opacity(0.8))
          Image(systemName: "chevron.right")
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(.b600.opacity(0.8))
            .rotationEffect(.degrees(self.isExpanded ? 90 : 0))
          Spacer()
        }
      }
      .padding(.leading, 12)

      VStack {
        ForEach(self.pieces) { piece in
          PieceView(piece)
        }
      }
      .padding(.top, 10)
      .frame(height: self.isExpanded ? nil : 0)
      .offset(y: self.isExpanded ? 0 : Double(self.pieces.count * 35))
      .opacity(self.isExpanded ? 1 : 0)
    }
    .padding(.top, 10)
    .padding(.horizontal, self.isExpanded ? 16 : 0)
    .padding(.bottom, self.isExpanded ? 20 : 10)
    .background(.b100.opacity(self.isExpanded ? 0 : 0.5))
    .cornerRadius(12)
    .padding(.horizontal, self.isExpanded ? 0 : 16)
    .padding(.bottom, self.isExpanded ? 10 : 20)
  }

  init(_ heading: String, pieces: [Piece]) {
    self.heading = heading
    self.pieces = pieces
  }
}

struct GroupedPieces {
  private var pieces: [Piece]

  func byFamiliarity(_ familiarity: FamiliarityLevel) -> [Piece] {
    self.pieces.filter { $0.familiarity == familiarity }
  }

  func byFamiliarity(_ familiarityLevels: [FamiliarityLevel]) -> [Piece] {
    self.pieces.filter { familiarityLevels.contains($0.familiarity) }
  }

  init(_ pieces: [Piece]) {
    self.pieces = pieces.sorted { $0.title < $1.title }
  }
}

#Preview {
  NavigationStack {
    RepertoireListView(
      store: Store(initialState: RepertoireList.State(
        pieces: Piece.list
      )) {
        RepertoireList()
      }
    )
  }
}
