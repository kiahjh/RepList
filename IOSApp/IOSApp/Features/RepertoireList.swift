import ComposableArchitecture
import SwiftUI

@Reducer
struct RepertoireList {
  @Reducer
  enum Destination {
    case userDetail(UserDetail)
    case pieceDetail(PieceDetail)
  }

  @ObservableState
  struct State {  // TODO: Add Equatable conformance
    @Shared(.listSectionCollapsedState) var listSectionCollapsedState

    @Presents var destination: Destination.State?

    var pieces: [Piece]
    var searchText: String = ""

    var filteredPieces: [Piece] {
      pieces.filter {
        searchText.isEmpty ? true : $0.title.lowercased().contains(self.searchText.lowercased())
      }
    }
  }

  enum ListSection {
    case learning
    case next
    case needsWork
    case learned
  }

  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case destination(PresentationAction<Destination.Action>)
    case pieceTapped(Piece)
    case sectionHeadingTapped(ListSection)
    case userDetailTapped
  }

  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .destination:
        return .none

      case .pieceTapped(let piece):
        state.destination = .pieceDetail(PieceDetail.State(piece: piece))
        return .none

      case .sectionHeadingTapped(let section):
        switch section {
        case .learning:
          state.$listSectionCollapsedState.withLock { $0.learning.toggle() }
        case .next:
          state.$listSectionCollapsedState.withLock { $0.next.toggle() }
        case .needsWork:
          state.$listSectionCollapsedState.withLock { $0.needsWork.toggle() }
        case .learned:
          state.$listSectionCollapsedState.withLock { $0.learned.toggle() }
        }
        return .none

      case .userDetailTapped:
        state.destination = .userDetail(UserDetail.State())
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }
}

struct RepertoireListView: View {
  @Bindable var store: StoreOf<RepertoireList>
  @Namespace private var namespace

  var groupedPieces: GroupedPieces {
    GroupedPieces(self.store.filteredPieces)
  }

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      ScrollView {
        VStack(spacing: 0) {
          PiecesListSection(
            heading: "Currently learning",
            pieces: self.groupedPieces.byFamiliarity(.learning),
            isCollapsed: self.store.listSectionCollapsedState.learning,
            namespace: namespace
          ) {
            self.store.send(.pieceTapped($0))
          } onCollapse: {
            self.store.send(.sectionHeadingTapped(.learning))
          }
          
          PiecesListSection(
            heading: "Next up",
            pieces: self.groupedPieces.byFamiliarity(.todo),
            isCollapsed: self.store.listSectionCollapsedState.next,
            namespace: namespace
          ) {
            self.store.send(.pieceTapped($0))
          } onCollapse: {
            self.store.send(.sectionHeadingTapped(.next))
          }
          
          PiecesListSection(
            heading: "Needing some work",
            pieces: self.groupedPieces.byFamiliarity(.playable),
            isCollapsed: self.store.listSectionCollapsedState.needsWork,
            namespace: namespace
          ) {
            self.store.send(.pieceTapped($0))
          } onCollapse: {
            self.store.send(.sectionHeadingTapped(.needsWork))
          }
          
          PiecesListSection(
            heading: "Learned",
            pieces: self.groupedPieces.byFamiliarity([.good, .mastered]),
            isCollapsed: self.store.listSectionCollapsedState.learned,
            namespace: namespace
          ) {
            self.store.send(.pieceTapped($0))
          } onCollapse: {
            self.store.send(.sectionHeadingTapped(.learned))
          }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        .padding(.bottom, 120)
      }
      .background(.b50.opacity(0.6))

      Button {
      } label: {
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
    .searchable(text: self.$store.searchText)
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button {
        } label: {
          Image(systemName: "ellipsis")
            .font(.system(size: 13, weight: .semibold))
            .frame(width: 30, height: 30)
            .background(.b200.opacity(0.6))
            .cornerRadius(15)
        }
      }
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          self.store.send(.userDetailTapped)
        } label: {
          Image(systemName: "person.fill")
            .font(.system(size: 13))
            .frame(width: 30, height: 30)
            .background(.b200.opacity(0.6))
            .cornerRadius(15)
        }
      }
    }
    .navigationDestination(
      item: self.$store.scope(state: \.destination?.userDetail, action: \.destination.userDetail)
    ) {
      store in
      UserDetailView(store: store)
    }
    .navigationDestination(
      item: self.$store.scope(state: \.destination?.pieceDetail, action: \.destination.pieceDetail)
    ) {
      store in
      PieceDetailView(store: store)
        .navigationTransition(.zoom(sourceID: store.piece.id, in: self.namespace))
        .navigationTitle(store.piece.title)
    }
  }
}

struct PiecesListSection: View {
  let heading: String
  let pieces: [Piece]
  let isCollapsed: Bool
  let namespace: Namespace.ID
  let onPieceTap: (Piece) -> Void
  var onCollapse: () -> Void

  init(
    heading: String,
    pieces: [Piece],
    isCollapsed: Bool,
    namespace: Namespace.ID,
    onPieceTap: @escaping (Piece) -> Void,
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
              PieceView(piece)
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
      store: Store(
        initialState: RepertoireList.State(
          pieces: Piece.list
        )
      ) {
        RepertoireList()
      }
    )
  }
}
